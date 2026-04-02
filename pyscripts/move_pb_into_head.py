import difflib
from pathlib import Path
from glob import glob
from acdh_tei_pyutils.tei import TeiReader


def resolve_path_relative_to_script(relative_path: str) -> Path:
    script_dir = Path(__file__).resolve().parent
    relative_path = Path(relative_path)
    return script_dir / relative_path


pb_with_following_head = """//tei:pb[
    not(following-sibling::node()[1][self::text()[normalize-space()]]) and
    (
        following-sibling::*[1][self::tei:head] or
        (
            following-sibling::*[1][self::tei:fw] and
            not(following-sibling::*[1]/following-sibling::node()[1][self::text()[normalize-space()]]) and
            following-sibling::*[1]/following-sibling::*[1][self::tei:head]
        )
    )
]"""

pb_with_following_head_in_different_container = """//tei:pb[
    not(following-sibling::node()[1][self::text()[normalize-space()]]) and
    (
        not(following-sibling::*) or
        (
            following-sibling::*[1][self::tei:fw] and
            not(following-sibling::*[1]/following-sibling::node()[1][self::text()[normalize-space()]]) and
            not(following-sibling::*[2])
        )
    ) and
    following::tei:head
]"""


def move_pb_to_following_head(pb):
    prev_sibling = pb.getprevious()
    prev_fw = None
    if prev_sibling is not None and prev_sibling.tag.endswith("fw"):
        if prev_sibling.tail is None or not prev_sibling.tail.strip():
            prev_fw = prev_sibling
    next_elem = pb.getnext()
    if next_elem is not None and next_elem.tag.endswith("head"):
        head = next_elem
        head.insert(0, pb)
        if prev_fw is not None:
            head.insert(0, prev_fw)
        pb.tail = head.text
        head.text = None
    elif next_elem is not None and next_elem.tag.endswith("fw"):
        fw = next_elem
        head = fw.getnext()
        head.insert(0, fw)
        head.insert(0, pb)
        if prev_fw is not None:
            head.insert(0, prev_fw)
        fw.tail = head.text
        head.text = None
    else:
        print(pb.attrib)
        raise ValueError("No suitable head found after pb")


def move_pb_to_head_in_different_container(pb):
    """Improved variant for the cross-container pb->head move.

    Compared to the original implementation, this version explicitly allows
    an immediate following <fw> as part of the page-break group while still
    forbidding any other non-whitespace text between the group and the head.
    """
    nsmap = {"tei": "http://www.tei-c.org/ns/1.0"}

    following_heads = pb.xpath("following::tei:head", namespaces=nsmap)
    if not following_heads:
        return False
    head = following_heads[0]

    # Do not move a pb into a head that already
    # contains its own page-break marker.
    if head.xpath(".//tei:pb", namespaces=nsmap):
        return False

    fw_element = pb.getnext()
    if fw_element is not None:
        # For the cross-container case we expect at most a single fw sibling
        # directly after pb, and no further element siblings.
        if not fw_element.tag.endswith("fw") or fw_element.getnext() is not None:
            raise ValueError("xpath for pb_with_following_head_in_different_container seems faulty")
        start_element = fw_element
    else:
        start_element = pb

    # All text nodes after start_element in document order
    all_following_text = start_element.xpath("following::text()", namespaces=nsmap)
    # All text nodes that are at or after the head
    all_head_following_text = head.xpath("following::text()", namespaces=nsmap)
    head_inner_text = head.xpath(".//text()", namespaces=nsmap)

    # Text nodes that lie strictly between start_element and the head
    between_texts = [
        t
        for t in all_following_text
        if t not in all_head_following_text and t not in head_inner_text
    ]

    filtered_between = []
    for t in between_texts:
        # lxml's text results support getparent()
        parent = t.getparent()
        # Allow the page number text of the immediate fw sibling
        if fw_element is not None and parent is fw_element:
            continue
        # Everything else with non-whitespace is considered blocking
        filtered_between.append(t)

    if any((t or "").strip() for t in filtered_between):
        # There is real text content between pb/fw and head – do not move
        return False

    # Move pb and optionally surrounding fw elements
    prev_fw_element = None
    prev_sibling = pb.getprevious()
    if prev_sibling is not None and prev_sibling.tag.endswith("fw"):
        if prev_sibling.tail is None or not prev_sibling.tail.strip():
            prev_fw_element = prev_sibling

    if fw_element is not None:
        if prev_fw_element is not None:
            head.insert(0, prev_fw_element)
        head.insert(0, fw_element)
        head.insert(0, pb)
        fw_element.tail = head.text
        head.text = None
    else:
        if prev_fw_element is not None:
            head.insert(0, prev_fw_element)
        head.insert(0, pb)
        pb.tail = head.text
        head.text = None
    return True


def move_pb_to_neighboring_container(pb):
    try:
        prev_sibling = pb.getprevious()
        prev_fw = None
        if prev_sibling is not None and prev_sibling.tag.endswith("fw"):
            if prev_sibling.tail is None or not prev_sibling.tail.strip():
                prev_fw = prev_sibling
                prev_sibling = prev_sibling.getprevious()
        next_fw = None
        next_sibling = pb.getnext()
        # Skip over non-Element siblings (e.g. Oxygen PI comments)
        while next_sibling is not None and not hasattr(next_sibling, "xpath"):
            next_sibling = next_sibling.getnext()
        if next_sibling is not None and next_sibling.tag.endswith("fw"):
            if next_sibling.tail is None or not next_sibling.tail.strip():
                next_fw = next_sibling
                next_sibling = next_sibling.getnext()
            else:
                return
        if next_sibling is not None:
            if next_sibling.xpath("local-name()") in ["p", "note"]:
                next_sibling.insert(0, pb)
                if next_fw is not None:
                    pb.addnext(next_fw)
                if prev_fw is not None:
                    pb.addprevious(prev_fw)
                if next_sibling.text is not None:
                    if next_fw is not None:
                        next_fw.tail = next_sibling.text
                    else:
                        pb.tail = next_sibling.text
                    next_sibling.text = None
    except AttributeError:
        print(f"Error processing pb: {pb.attrib}")


def move_pbs_in_reader(reader, tei_file: str = "<in-memory>") -> bool:
    """Apply the v2 pb->head moves on an existing TeiReader without writing.

    Returns True if any structural change was performed.
    """
    print(f"[v2] Processing file: {tei_file}")
    old_text = "\n".join([x for x in reader.any_xpath("//text()[normalize-space()]")])
    pbs_with_heads = reader.any_xpath(pb_with_following_head)
    pbs_with_heads_in_different_container = reader.any_xpath(pb_with_following_head_in_different_container)
    pbs_in_divs = reader.any_xpath("//tei:div/tei:pb")

    changed = bool(pbs_with_heads + pbs_in_divs)

    for pb_in_div in pbs_in_divs:
        move_pb_to_neighboring_container(pb_in_div)
    for pb in pbs_with_heads:
        move_pb_to_following_head(pb)
    for pb in pbs_with_heads_in_different_container:
        if move_pb_to_head_in_different_container(pb):
            changed = True
            print(f"[v2] Moved pb in next container: {tei_file}")
            print(f"[v2] {pb.attrib}")

    if changed:
        new_text = "\n".join([x for x in reader.any_xpath("//text()[normalize-space()]")])
        if old_text != new_text:
            old_lines = old_text.split("\n")
            new_lines = new_text.split("\n")
            for i in range(len(new_lines)):
                new_line = new_lines[i]
                if new_line != old_lines[i]:
                    print(f"[v2] Difference at line {i+1}:")
                    print("[v2] Old line:")
                    print(old_lines[i])
                    print("[v2] New line:")
                    print(new_line)
            raise ValueError("[v2] Text changed after moving pb elements")
    return changed


def move_pbs(tei_file: str) -> bool:
    reader = TeiReader(tei_file)
    changed = move_pbs_in_reader(reader, tei_file)
    if changed:
        reader.tree_to_file(tei_file)
    return changed


if __name__ == "__main__":
    data_path = resolve_path_relative_to_script("../data/editions")
    input_files = glob(str(data_path / "*.xml"))
    for input_file in input_files:
        move_pbs(input_file)
