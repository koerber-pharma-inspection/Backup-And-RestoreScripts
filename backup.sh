#!/bin/bash


# version 1.0

##This script will loop though the config file
## Then take all files needed and create a backup
## The script will Zip the backup with 7z


## Datacollector Backupscript
## Config file is neaded to run this script

## Tools needed for this Script
# 1. Install Rsync
# 2. Install 7z for Linux



## VARIABLES
name=$(date '+BACKUP_archieve-%F-%H-%M-%S.7z')

## FUNCTIONS

backup () {
        echo "start......"

        ## collect from data collector to Backup directory
        ## check if rsync is installed locally, (tool)
        ## -s means if file exists and has a size greater than zero

        if [ ! -s /usr/bin/rsync ]; then
                echo "using cp instead of rsync"
                cp -pr ${CONF_DIR}/* ${BACK_DIR}/
        else
                for i in ${CONF_DIR[@]}; do

                        echo "collecting configuration files..."
                        rsync -avH --delete --progress $i ${BACK_DIR}
                        echo "BACKUP file created."

                        ## check if rsync ended succesfully
                        [ ! $? ] && echo "rsync failed"
                done

        fi

        echo "configurations collected successfully"
        
        # call here cleanup function to delete folders after zip
        zip && cleanup

        exit 0


}

# install 7zip inorder to compress with 7z
zip () {

        # tar czf Datacollector"$name"  ${BACK_DIR}
        7z a /home/vision/backup/"$name" ${BACK_DIR}

        echo "Backup file compressed to zip folder successfully.."


}

cleanup () {

        ## clean all other files except 7z ##
        cd ${BACK_DIR}
        #Deletes file type except *.7z
        rm -rf $(ls -I "*.7z")
        echo "Backup cleanup successfully"

        exit 0
}

################################ START #######################################

## check if the configuration file is available
if [ ! -f config ]; then
        echo "config file not available"
        exit 1
else
        source $PWD/config
fi

## proof if the datacollector Backup directory exists
if [ ! -d ${BACK_DIR} ]; then
        mkdir ${BACK_DIR}
        exit 1
fi


## proof if the datacollector config directory exists
if [ ! -d ${CONF_DIR} ]; then
        echo "please check the conf directory"
        exit 1
fi



## call Function
backup;



exit 0
