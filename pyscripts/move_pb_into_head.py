from glob import glob
from acdh_tei_pyutils.tei import TeiReader

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
            not(following-sibling::*)
        )
    )
]"""

xpath_expression = f"{pb_with_following_head} | {pb_with_following_head_in_different_container}"

def move_pb_to_following_head(pb):
    next_elem = pb.getnext()
    if next_elem is not None and next_elem.tag.endswith('head'):
        head = next_elem
        head.insert(0, pb)
    elif next_elem is not None and next_elem.tag.endswith('fw'):
        fw = next_elem
        head = fw.getnext()
        head.insert(0, fw)
        head.insert(0, pb)
    else:
        raise ValueError("No suitable head found after pb")

def move_pb_to_head_in_different_container(pb):
    parent = pb.getparent()
    next_container = parent.getnext()
    while next_container is not None:
        head = next_container.find('.//{*}head')
        if head is not None:
            head.insert(0, pb)
            return
        next_container = next_container.getnext()
    raise ValueError("No suitable head found in following containers")

def move_pbs(tei_file):
    print(f"Processing file: {tei_file}")
    try:
        reader = TeiReader(tei_file)
        for pb in reader.any_xpath(xpath_expression):
            move_pb_to_following_head(pb)
        for pb in reader.any_xpath(pb_with_following_head_in_different_container):
            move_pb_to_head_in_different_container(pb)
        reader.tree_to_file(tei_file)
    except Exception as e:
        print(f"Error processing {tei_file}: {e}")

input_files = glob("bv-working-data/data/editions/*.xml")
for input_file in input_files:
    output = move_pbs(input_file)

