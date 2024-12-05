#!/bin/bash
TEX_DIR="./tex/"
PDF_TARGET_DIR="./html/pdf-sources"
LATEX_LOGS=$PDF_TARGET_DIR"/logs"

# clean slate
rm -r $PDF_TARGET_DIR
# this creates/ensures LATEX_LOGS *AND* PDF_TARGET
# because of p-Flag!!
if [ ! -d "$LATEX_LOGS" ]; then
  echo "Directory $LATEX_LOGS does not exist. Creating it now."
  mkdir -p $LATEX_LOGS
fi

find $TEX_DIR -type f -name '*.tex' -exec xelatex -interaction=nonstopmode -output-directory=$PDF_TARGET_DIR {} \;
find $PDF_TARGET_DIR -maxdepth 1 -type f -name '*.aux' -exec mv {} $LATEX_LOGS \;
find $PDF_TARGET_DIR -maxdepth 1 -type f -name '*.log' -exec mv {} $LATEX_LOGS \;
rm -r $TEX_DIR