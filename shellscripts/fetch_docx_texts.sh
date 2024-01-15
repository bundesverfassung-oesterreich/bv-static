RETRIEVED_TEXTS_DIR="./data/externally_sourced_texts/"
if [ -d $RETRIEVED_TEXTS_DIR ]; then rm -rf $RETRIEVED_TEXTS_DIR; fi
mkdir $RETRIEVED_TEXTS_DIR
wget https://github.com/bundesverfassung-oesterreich/bv-commentary-parser/raw/main/tei/about_bvg.xml -P $RETRIEVED_TEXTS_DIR
wget https://raw.githubusercontent.com/bundesverfassung-oesterreich/bv-commentary-parser/main/tei/about_project.xml -P $RETRIEVED_TEXTS_DIR
wget https://raw.githubusercontent.com/bundesverfassung-oesterreich/bv-commentary-parser/main/tei/index.xml -P $RETRIEVED_TEXTS_DIR