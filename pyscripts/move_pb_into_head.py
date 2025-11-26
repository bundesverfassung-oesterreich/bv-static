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

xpath_expression = f"{pb_with_following_head} | {pb_with_following_head_in_different_container}"

def move_pb_to_following_head(pb):
    next_elem = pb.getnext()
    if next_elem is not None and next_elem.tag.endswith('head'):
        head = next_elem
        head.insert(0, pb)
        pb.tail = head.text
        head.text = None
    elif next_elem is not None and next_elem.tag.endswith('fw'):
        fw = next_elem
        head = fw.getnext()
        head.insert(0, fw)
        head.insert(0, pb)
        fw.tail = head.text
        head.text = None
    else:
        raise ValueError("No suitable head found after pb")

def move_pb_to_head_in_different_container(pb):
    # Find the next head in document order
    nsmap = {'tei': 'http://www.tei-c.org/ns/1.0'}
    following_heads = pb.xpath('following::tei:head', namespaces=nsmap)
    # assume there is at least one head following, as per the xpath selection
    head = following_heads[0]
    # Check if there are non-whitespace text nodes between pb/fw and head
    # Get all text nodes between pb and head
    fw_element = pb.getnext()
    if fw_element is not None:
        if not fw_element.tag.endswith('fw') or fw_element.getnext() is not None:
            raise ValueError("xpath seems faulty")
        start_element = fw_element
    else:
        start_element = pb
    all_following_text = start_element.xpath('following::text()', namespaces=nsmap)
    all_head_following_text = head.xpath('following::text()', namespaces=nsmap)
    # Get text nodes that are after start_element but before head
    between_texts = [t for t in all_following_text if t not in all_head_following_text and t not in head.xpath('.//text()', namespaces=nsmap)]
    # If there's any non-whitespace text between them, skip
    if any(t.strip() for t in between_texts):
        return False
    # Move pb and optionally fw
    if fw_element is not None:
        head.insert(0, fw_element)
        head.insert(0, pb)
        fw_element.tail = head.text
        head.text = None
    return True

def move_pbs(tei_file):
    print(f"Processing file: {tei_file}")
    try:
        reader = TeiReader(tei_file)
        for pb in reader.any_xpath(xpath_expression):
            move_pb_to_following_head(pb)
        for pb in reader.any_xpath(pb_with_following_head_in_different_container):
            if move_pb_to_head_in_different_container(pb):
                print(f"Moved pb in next container: {tei_file}")
                print(f"{pb.attrib}")
        reader.tree_to_file(tei_file)
    except Exception as e:
        print(f"Error processing {tei_file}: {e}")

data_path = resolve_path_relative_to_script("../data/editions")
input_files = glob(str(data_path / "*.xml"))
for input_file in input_files:
    output = move_pbs(input_file)