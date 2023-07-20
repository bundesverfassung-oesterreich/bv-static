#!/bin/bash
sourcefiles="./data/editions/bv_doc_id__6.xml"
xsl_script="./xslt/navigation_layer.xsl"
for sourcefile in $sourcefiles
do
    tempfile="$sourcefile.tmp"
    java -jar ./saxon/saxon9he.jar -o:$tempfile -s:$sourcefile $xsl_script
    mv $tempfile $sourcefile
done