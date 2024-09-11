#!/bin/bash
# # def vars
temp_path="./tmp_tmp/"
zip_file="${temp_path}main.zip"
fetched_editions_path="${temp_path}bv-data-main/data/editions/"
fetched_commentaries_path="${temp_path}bv-data-main/data/commentaries/"
target_editions_path="./data/editions/"
target_commentaries_path="./data/commentaries/"
# # prepare folder structure
rm -rf $temp_path
mkdir $temp_path
# # fetch data from repo, unzip, and move to destination
wget https://github.com/bundesverfassung-oesterreich/bv-data/archive/refs/heads/main.zip -O $zip_file
unzip $zip_file -d $temp_path
# # check for target dir
if [ ! -d "$target_editions_path" ]; then mkdir "$target_editions_path"; fi
if [ ! -d "$target_commentaries_path" ]; then mkdir "$target_commentaries_path"; fi
find $fetched_editions_path -name "*.xml" -exec cp "{}" "$target_editions_path" \;
find $fetched_commentaries_path -name "*.xml" -exec cp "{}" "$target_commentaries_path" \;
# # remove temp folder
rm -rf $temp_path