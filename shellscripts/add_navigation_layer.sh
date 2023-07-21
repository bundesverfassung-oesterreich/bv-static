#!/bin/bash
sourcefiles="./data/editions/bv_doc_id__*.xml"
xsl_script="./xslt/navigation_layer.xsl"
for sourcefile in $sourcefiles
do
    tempfile="$sourcefile.tmp"
    echo "creating navigation anchor in $sourcefile"
    java -jar ./saxon/saxon9he.jar -o:$tempfile -s:$sourcefile $xsl_script
    if [ $? != 0 ]; then
        echo "error while creating navigation anchor in $sourcefile"
        exit 1
    fi
    mv $tempfile $sourcefile
done