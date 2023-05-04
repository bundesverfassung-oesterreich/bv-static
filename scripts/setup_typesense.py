import glob
import os
from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


page_base_url = "https://bundesverfassung-oesterreich.github.io/bv-static/"
typesense_collection_name = "bundes_verfassung_oesterreich"
html_path = "./html/*"


def setup_collection():
    print(f"setting up collection '{typesense_collection_name}'")
    current_schema = {
        "name": typesense_collection_name,
        "fields": [
            {"name": "bv_id", "type": "string"},
            {"name": "title", "type": "string"},
            {"name": "full_text", "type": "string"},
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


def create_record(
    head, creation_date, creation_start, doc_title, bv_doc_id, authors, file_name
):
    record = {}
    # # cfts_record = {"project": typesense_collection_name}
    content_elements = [head]
    nex = head.getnext()
    while nex is not None and nex.xpath("local-name()='p' or local-name()='pb'"):
        content_elements.append(nex)
        nex = nex.getnext()
    full_text = "\n".join(
        " ".join("".join(el.itertext()).split()) for el in content_elements
    )
    record["full_text"] = full_text
    if len(record["full_text"]) > 0:
        head_id = head.xpath("@id")[0]
        head_path = f"{file_name}#{head_id}"
        record["id"] = head_path
        record["resolver"] = f"{page_base_url}/{head_path}"
        record["bv_id"] = bv_doc_id
        title = doc_title + head.text
        record["title"] = title
        if authors:
            record["persons"] = authors
        if creation_date:
            record["year"] = int(creation_date)
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
        creation_date = xml_doc.any_xpath(
            "normalize-space(//tei:profileDesc/tei:creation/tei:date/text()[1])"
        )
        creation_start = xml_doc.any_xpath(
            "normalize-space(//tei:profileDesc/tei:creation/tei:date/@from[1])"
        )
        doc = TeiReader(html_filepath)
        # # this aint pretty but it’s working:
        doc.ns_tei = {"tei": "http://www.w3.org/1999/xhtml"}
        doc_title = doc.any_xpath("/tei:html/tei:head/tei:title")[0].text
        file_name = os.path.split(html_filepath)[-1]
        bv_doc_id = file_name.replace(".html", "").strip()
        heads = doc.any_xpath(
            "//tei:div[@class='card-body']/*[local-name()='h2' or local-name()='h3' or local-name()='h4']"
        )
        records += [
            create_record(
                head,
                creation_date,
                creation_start,
                doc_title,
                bv_doc_id,
                authors,
                file_name,
            )
            for head in heads
        ]
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

# # search_ps = {'q': 'Test', 'query_by': 'full_text'}
# # example_request = client.collections[typesense_collection_name].documents.search(search_ps)
