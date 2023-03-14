#!/bin/bash
# # def vars
temp_path="./tmp_tmp/"
zip_file="${temp_path}main.zip"
fetched_editions_path="${temp_path}bv-working-data-main/data/editions/"
target_editions_path="./data/editions/"
# # prepare folder structure
rm -rf $temp_path
mkdir $temp_path
# # fetch data from repo, unzip, and move to destination
wget https://github.com/bundesverfassung-oesterreich/bv-working-data/archive/refs/heads/main.zip -O $zip_file
unzip $zip_file -d $temp_path
find $fetched_editions_path -name "*.xml" -exec cp "{}" "$target_editions_path" \;
# # remove temp folder
rm -rf $temp_path