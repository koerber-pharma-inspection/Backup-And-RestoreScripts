#!/bin/bash

# Restore Script



## FUNCTION
# install 7z for Linux
# command e is used to decompress or extract files and folder
# The Script will create a restore directory and extract the current
# zip from Backup Directory

unzip () {

        cd ${BACK_DIR}
        file=`ls -t *.7z | tail -1`
        # check for the latest Backup folder to extract
        #file=$(ls -ltr ${BACK_DIR}/*.7z | tail -1)

        # extract with 7z
        7z x $file -o${REST_DIR}

        echo "Restore was successfull"
        # restore


}


# can use rync function to send backup files to Destination directory
# DEST_DIR = home/vision
restore () {

        # Transfer the folders to
        rsync -avH --progress ${REST_DIR}/* ${DEST_DIR}


        echo "Configuration files were transferred successfull"
        exit 0
}
###### START #######################################

## check if the configuration file is available
if [ ! -f config ]; then
        echo "config file not available"
        exit 1
else
        source $PWD/config
fi



## proof if the datacollector Dest directory exists
if [ ! -d ${BACK_DIR} ]; then
        echo "please check the Backup directory"
        exit 1
fi

## proof if the datacollector Restore directory exists
if [ ! -d ${REST_DIR} ]; then
        mkdir ${REST_DIR}
        # echo "Restore Directory created Successfully"
        exit 1
fi


unzip
exit 0
