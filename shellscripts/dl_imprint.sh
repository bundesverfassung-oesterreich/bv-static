#!/bin/bash

REDMINE_ID=21497
IMPRINT_XML=./data/imprint.xml
rm ${IMPRINT_XML}
echo '<?xml version="1.0" encoding="UTF-8"?>' >> ${IMPRINT_XML}
echo "<root><div>" >> ${IMPRINT_XML}
curl "https://imprint.acdh.oeaw.ac.at/${REDMINE_ID}?locale=de&format=xhtml" >> ${IMPRINT_XML}
echo "</div></root>" >> ${IMPRINT_XML}