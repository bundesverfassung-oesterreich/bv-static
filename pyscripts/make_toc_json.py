import re
import glob
import json
from acdh_tei_pyutils.tei import TeiReader

json_path = "./html/js/toc.json"
editions_path = "./data/editions/*.xml"
doc_id_2_data = {}
toc = []


def normalize_space(text):
    """
    Normalize whitespace in a string by replacing multiple spaces and newlines with a single space.
    """
    return re.sub(r'\s+', ' ', text).strip()


for edition_file in glob.glob(editions_path):
    print(edition_file)
    data = {}
    doc = TeiReader(edition_file)
    data_set = doc.any_xpath("//tei:idno[@type='bv_data_set']/text()")[0].strip()
    data["data_set"] = data_set
    try:
        data["witness_status"] = doc.any_xpath("//tei:sourceDesc//tei:msDesc/@subtype")[0].strip()
    except IndexError:
        data["witness_status"] = "primary"
    data["other_witnesses"] = [
        doc_id.strip("#")
        for doc_id in doc.any_xpath("//tei:sourceDesc/tei:listWit/tei:witness/@sameAs")
    ]
    title_prefix = "Alternativzeuge: " if data["witness_status"] != "primary" else ""
    title_str = normalize_space(doc.any_xpath(".//tei:title[@type='main'][1]/text()")[0])
    title_html = f"""
        {title_prefix}<a href="{edition_file.split("/")[-1].replace('.xml', '.html')}">
            {title_str}
        </a>
    """
    data["title_html"] = re.sub("[\n]*|\s{2,}", "", title_html)
    persons_string = " / ".join(
        doc.any_xpath("//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()")
    )
    data["beteiligte Personen"] = re.sub("[\n]*|\s{2,}", "", normalize_space(persons_string))
    data["Dokumententyp"] = doc.any_xpath("//tei:text/@type")[0]
    data["Materialtyp"] = doc.any_xpath(
        "//tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/@form[1]"
    )[0]
    date_val = doc.any_xpath(
        "//tei:profileDesc/tei:creation/tei:date/@notBefore-iso[1]"
    )[0].strip() + "|" + doc.any_xpath(
        "//tei:seriesStmt/tei:biblScope/text()"
    )[0].strip()
    data["Entstehung (tpq)"] = date_val
    revision_desc = doc.any_xpath(".//tei:revisionDesc/@status")[0].strip()
    revision_state = "maschinell erfasst"
    match revision_desc:
        case "structured":
            revision_state = "strukturell erschlossen"
        case "text_correct":
            revision_state = "vollständig ediert"
        case "done":
            revision_state = "vollständig ediert"
        case _:
            pass  # keep default 'maschinell erfasst'

    data["Erschließungsgrad"] = revision_state
    bv_doc_id = doc.tree.getroot().attrib[f'{{{doc.ns_xml.get("xml")}}}id']

    doc_id_2_data[bv_doc_id] = data
    if data["witness_status"] == "primary":
        toc.append(data)

for data in toc:
    if data["other_witnesses"]:
        data["_children"] = []
        for witness_id in data["other_witnesses"]:
            if witness_id in doc_id_2_data:
                data["_children"].append(doc_id_2_data[witness_id])
            else:
                print(f"Warning: Witness ID {witness_id} not found in doc_id_2_data.")
        if len(data["_children"]) == 0:
            # we have to remove this, otherwise tabulator will show a non working dropdown
            data.pop("_children")
            data.pop("other_witnesses")

# sort by:
# 1. Data Set (A-C)
# 2. Entstehung (tpq), split by "|" and sort by first part (date), then by second part (biblScope)
toc = sorted(toc, key=lambda x: (x["data_set"], x["Entstehung (tpq)"].split("|")[0], x["Entstehung (tpq)"].split("|")[1]))
with open(json_path, "w") as f:
    print(f"Writing toc to {json_path}")
    json.dump(toc, f, indent=2)
