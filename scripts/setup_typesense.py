import glob
import os
import re
from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


page_base_url = "https://bundesverfassung-oesterreich.github.io/bv-static/"
typesense_collection_name = "bundes_verfassung_oesterreich"
html_path = "./html/*"

if not os.path.exists(html_path.strip("*")):
    print(f"\nhtml dir {html_path} not found!")


def setup_collection():
    print(f"setting up collection '{typesense_collection_name}'")
    current_schema = {
        "name": typesense_collection_name,
        "enable_nested_fields": False,
        "default_sorting_field" : "default_sort",
        "fields": [
            {"name": "doc_internal_orderval", "type": "int32"},
            {"name": "record_type", "type": "string", "facet": True},
            {"name": "bv_doc_id", "type": "string"},
            {"name": "bv_doc_id_num", "type": "int32"},
            {"name": "Dokumententitel", "type": "string", "facet": True},
            {"name": "title", "type": "string"},
            {"name": "full_text", "type": "string"},
            {"name": "record_id", "type": "string"},
            {"name": "anker_link", "type": "string"},
            {"name": "Materialart", "type": "string", "facet": True},
            {"name": "Dokumententyp", "type": "string", "facet": True},
            {"name": "Personen", "type": "string[]", "facet": True, "optional": True},
            {"name": "creation_year", "type": "int32", "facet": True},
            {"name": "creation_date", "type": "int32"},
            {"name": "creation_date_autopsic", "type": "string", "facet": True},
            {"name": "default_sort", "type":"int32", "facet": False}
        ],
    }
    try:
        client.collections[typesense_collection_name].delete()
        print(f"resetted collection '{typesense_collection_name}'")
    except ObjectNotFound:
        pass
    client.collections.create(current_schema)
    print(f"created collection '{typesense_collection_name}'")


def remove_lb_hyphens(string):
    string = re.sub("\s?\n\s?|\s{2,}", " ", string)
    lowercase = "[a-zäöü]"
    hypen_regex = f"(?<={lowercase})- (?={lowercase})(?!und)"
    return re.sub(hypen_regex, "", string)


def get_full_text(head):
    if head is None:
        return ""
    content_elements = [head]
    nex = head.getnext()
    while nex is not None and nex.xpath("local-name()='p' or local-name()='pb'"):
        content_elements.append(nex)
        nex = nex.getnext()
    full_text = "\n".join(
        " ".join("".join(el.itertext()).split()) for el in content_elements
    )
    return remove_lb_hyphens(full_text.strip())


def create_record(
    head_index: int,
    head,
    creation_date,
    doc_title: str,
    bv_doc_id,
    authors,
    file_name,
    material_doc_type,
    doc_content_type,
):
    record = {}
    full_text = get_full_text(head)
    if not full_text and head_index == 0:
        full_text = doc_title.strip()
    if full_text:
        record["full_text"] = full_text
        record["doc_internal_orderval"] = head_index
        record["record_type"] = (
            "Dokumententitel" if head_index == 0 else head.attrib["class"]
        )
        record["bv_doc_id"] = bv_doc_id
        record["bv_doc_id_num"] = int(bv_doc_id.split("_")[-1])
        record["Dokumententitel"] = doc_title
        if head is not None:
            title = f"{doc_title}: {head.text}"
        else:
            title = doc_title
        record["title"] = title
        head_id = head.xpath("@id")[0] if head is not None else ""
        head_path = f"{file_name}#{head_id}"
        record["record_id"] = head_path
        record["anker_link"] = f"./{file_name}#{head_id}"
        if authors:
            record["Personen"] = authors
        if creation_date:
            record["creation_date"] = int(creation_date.replace("-", ""))
            record["creation_date_autopsic"] = creation_date.split("-")[0]
            record["creation_year"] = int(record["creation_date_autopsic"])
        else:
            record["creation_date"] = 99991224
            record["creation_date_autopsic"] = "unbekannt"
            record["creation_year"] = 1900
        record["Materialart"] = material_doc_type
        record["Dokumententyp"] = doc_content_type
    return record


def create_records():
    print("creating records")
    html_files = [
        f for f in glob.glob(html_path) if ("bv_doc" in f) and f.endswith(".html")
    ]
    print(f"loaded total of {len(html_files)} files")
    records = []
    for html_filepath in tqdm(html_files, total=len(html_files)):
        print("processing", html_filepath)
        xml_doc = TeiReader(html_filepath.replace(".html", ".xml"))
        authors = xml_doc.any_xpath(
            "//tei:msDesc/tei:msContents/tei:msItem/tei:author/text()"
        )
        creation_date = xml_doc.any_xpath(
            "normalize-space(//tei:profileDesc/tei:creation/tei:date/@from[1])"
        )
        try:
            material_doc_type = xml_doc.any_xpath(
                "//tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/@form"
            )[0]
        except IndexError:
            material_doc_type = "unbekannt"
        try:
            doc_content_type = xml_doc.any_xpath("//tei:text/@type")[0]
        except IndexError:
            doc_content_type = ""
        doc = TeiReader(html_filepath)
        doc.ns_tei = {"tei": "http://www.w3.org/1999/xhtml"}
        doc_title = doc.any_xpath("/tei:html/tei:head/tei:title")[0].text
        file_name = os.path.split(html_filepath)[-1]
        bv_doc_id = file_name.replace(".html", "").strip()
        heads = doc.any_xpath(
            "//tei:div[@class='card-body']/*[local-name()='h2' or local-name()='h3' or local-name()='h4']"
        )
        head_index = 0
        doc_record = create_record(
            head_index,
            None,
            creation_date,
            doc_title,
            bv_doc_id,
            authors,
            file_name,
            material_doc_type,
            doc_content_type,
        )
        records.append(doc_record)
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
                doc_content_type,
            )
            records.append(record)
    return records


def upload_records(records):
    print(f"uploading '{len(records)}' records")
    setup_collection()
    print(f"uploading to {typesense_collection_name}")
    make_index = client.collections[typesense_collection_name].documents.import_(
        records, {"action": "upsert"}
    )
    errors = [
        msg for msg in make_index if (msg != '"{\\"success\\":true}"' and msg != '""')
    ]
    if errors:
        for err in errors:
            print(err)
    else:
        print("\nno errors")
    print(f'\ndone with indexing "{typesense_collection_name}"')
    return make_index


def add_sort_val_2_records(records):
    records.sort(
        key = lambda x: (
            x["creation_date"],# creation_date:asc
            x["bv_doc_id_num"],# bv_doc_id_num:asc
            x["doc_internal_orderval"]# doc_internal_orderval:asc
        )
    )
    index = 0
    total = len(records)
    for record in records:
        sortindex = total - index
        record["default_sort"] = sortindex
        index += 1
    return records


if __name__ == "__main__":
    records = create_records()
    sorted_records = add_sort_val_2_records(records)
    result = upload_records(sorted_records)

# # search_ps = {'q': 'Test', 'query_by': 'full_text'}
# # example_request = client.collections[typesense_collection_name].documents.search(search_ps)
