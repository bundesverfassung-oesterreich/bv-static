#!/bin/bash

REDMINE_ID=21497
IMPRINT_XML=./data/imprint.xml
rm ${IMPRINT_XML}
echo '<?xml version="1.0" encoding="UTF-8"?>' >> ${IMPRINT_XML}
echo "<root>" >> ${IMPRINT_XML}
curl https://imprint.acdh.oeaw.ac.at/${REDMINE_ID}?locale=de >> ${IMPRINT_XML}
curl https://imprint.acdh.oeaw.ac.at/${REDMINE_ID}?locale=en >> ${IMPRINT_XML}
sed -i 's/<br>/<lb\/>/g' $IMPRINT_XML
echo "</root>" >> ${IMPRINT_XML}