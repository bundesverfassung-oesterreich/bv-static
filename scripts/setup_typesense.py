import glob
import os
from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


page_base_url = "https://bundesverfassung-oesterreich.github.io/bv-static/"
typesense_collection_name = "bundes_verfassung_oesterreich"
html_path = "../html/*"


def setup_collection():
    print(f"setting up collection '{typesense_collection_name}'")
    current_schema = {
        "name": typesense_collection_name,
        "fields": [
            {"name": "doc_internal_orderval", "type": "int32"},
            {"name": "record_type", "type": "string"},
            # article, section, or doc
            {"name": "bv_doc_id", "type": "string"},
            {"name": "title", "type": "string"},
            {"name": "full_text", "type": "string"},
            {"name": "record_id", "type": "string"},
            {"name": "anker_link", "type": "string"},
            {"name": "material_doc_type", "type": "string", "facet": True},
            {
                "name": "year",
                "type": "int32",
                "optional": True,
                "facet": True,
            },
            {"name": "persons", "type": "string[]", "facet": True, "optional": True},
        ],
    }
    try:
        client.collections[typesense_collection_name].delete()
        print(f"resetted collection '{typesense_collection_name}'")
    except ObjectNotFound:
        pass
    client.collections.create(current_schema)
    print(f"created collection '{typesense_collection_name}'")


def get_full_text(head):
    content_elements = [head]
    nex = head.getnext()
    while nex is not None and nex.xpath("local-name()='p' or local-name()='pb'"):
        content_elements.append(nex)
        nex = nex.getnext()
    full_text = "\n".join(
        " ".join("".join(el.itertext()).split()) for el in content_elements
    )
    return full_text.strip()


def create_record(
    head_index: int,
    head,
    creation_date,
    doc_title,
    bv_doc_id,
    authors,
    file_name,
    material_doc_type,
    doc_content_type,
):
    record = {}
    record["full_text"] = get_full_text(head)
    if record["full_text"]:
        record["doc_internal_orderval"] = head_index
        record["record_type"] = "doc" if head_index == 0 else head.attrib["class"]
        record["bv_doc_id"] = bv_doc_id
        title = doc_title + head.text
        record["title"] = title
        head_id = head.xpath("@id")[0]
        head_path = f"{file_name}#{head_id}"
        record["record_id"] = head_path
        record["anker_link"] = f"{page_base_url}/{file_name}#{head_id}"
        if authors:
            record["persons"] = authors
        if creation_date:
            record["year"] = int(creation_date)
        record["material_doc_type"] = material_doc_type
        record["doc_content_type"] = doc_content_type
    return record


def create_records():
    print("creating records")
    html_files = [
        f for f in glob.glob(html_path) if ("bv_doc" in f) and f.endswith(".html")
    ]
    records = []
    for html_filepath in tqdm(html_files, total=len(html_files)):
        print("processing", html_filepath)
        xml_doc = TeiReader(html_filepath.replace(".html", ".xml"))
        authors = xml_doc.any_xpath(
            "//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()"
        )
        try:
            creation_date = xml_doc.any_xpath(
                "normalize-space(//tei:profileDesc/tei:creation/tei:date/text()[1])"
            )[0]
        except IndexError:
            creation_date = "unbekannt"
        try:
            creation_start = xml_doc.any_xpath(
                "normalize-space(//tei:profileDesc/tei:creation/tei:date/@from[1])"
            )[0]
        except IndexError:
            creation_start = "unbekannt"
        try:
            material_doc_type = (
                "//tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/@form"[0]
            )
        except IndexError:
            material_doc_type = "unbekannt"
        doc_content_type = xml_doc.any_xpath("//tei:text/@type")
        doc = TeiReader(html_filepath)
        doc.ns_tei = {"tei": "http://www.w3.org/1999/xhtml"}
        doc_title = doc.any_xpath("/tei:html/tei:head/tei:title")[0].text
        file_name = os.path.split(html_filepath)[-1]
        bv_doc_id = file_name.replace(".html", "").strip()
        heads = doc.any_xpath(
            "//tei:div[@class='card-body']/*[local-name()='h2' or local-name()='h3' or local-name()='h4']"
        )
        head_index = 0
        for head in heads:
            head_index += 1
            record = create_record(
                head_index,
                head,
                creation_date,
                doc_title,
                bv_doc_id,
                authors,
                file_name,
                material_doc_type,
                doc_content_type
            )
            records.append(record)
    return records


def upload_records(records):
    setup_collection()
    print(f"uploading to {typesense_collection_name}")
    make_index = client.collections[typesense_collection_name].documents.import_(
        records, {"action": "upsert"}
    )
    errors = [msg for msg in make_index if msg != '"{\\"success\\":true}"']
    if errors:
        for err in errors:
            print(err)
    else:
        print("\nno errors")
    print(f'\ndone with indexing "{typesense_collection_name}"')
    return make_index


if __name__ == "__main__":
    records = create_records()
    result = upload_records(records)
    errors = [x for x in result if x != '"{\\"success\\":true}"']
    if errors:
        print("Errors while creating ts-collection, this will affect the search.")
        print("/n".join(errors))
# # search_ps = {'q': 'Test', 'query_by': 'full_text'}
# # example_request = client.collections[typesense_collection_name].documents.search(search_ps)
