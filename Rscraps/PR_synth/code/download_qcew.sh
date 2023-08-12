#!/bin/bash

# Base URL for the data
base_url="https://data.bls.gov/cew/data/files"

# Directory where the files will be moved and unzipped
target_dir="/pool001/maximm/inter/qcew/"

# Loop over years from 1990 to 2022
for year in {1990..2022}
do
    # Construct the full URL for the zip file
    file_url="${base_url}/${year}/csv/${year}_qtrly_singlefile.zip"

    # Construct the name of the zip file
    file_name="${year}_qtrly_singlefile.zip"
    
    # Download the file using wget
    wget $file_url

    # Move the downloaded file to the target directory
    mv $file_name $target_dir

    # Change to the target directory
    cd $target_dir

    # Unzip the file
    unzip $file_name

    # Change back to the original directory
    cd -

done
