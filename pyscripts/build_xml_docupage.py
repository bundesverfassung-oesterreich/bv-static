from lxml import etree, html
import requests as req

template_path = "html/index.html"
docu_path = "html/xml_docu.html"

xml_docu_req = req.get('https://raw.githubusercontent.com/bundesverfassung-oesterreich/bv-schema-framework/main/html/index.html')
xml_docu_html = html.fromstring(xml_docu_req.content)
docu_nav_html = xml_docu_html.xpath("//body/ul[@class='toc toc_body']")[0]
docu_html = xml_docu_html.xpath("//body/div[@class='tei_body']")[0]

with open(template_path, 'rb') as template_file:
    template_html = html.parse(template_file)

template_container = template_html.xpath("//div[@class='container']")[0]
template_container.attrib["class"] += " xmldocumentation"
spacer_div = etree.Element("div")
spacer_div.attrib["class"] = "xml_docu_spacer"
if template_container is not None and docu_nav_html is not None and docu_html is not None:
    for child in template_container:
        template_container.remove(child)
    template_container.append(spacer_div)
    template_container.append(docu_html)
    template_container.append(docu_nav_html)



with open(docu_path, 'wb') as output_file:
    print(f"creating {docu_path}")
    output_file.write(
        etree.tostring(
            template_html,
            pretty_print=True,
            method="html"
        )
    )
