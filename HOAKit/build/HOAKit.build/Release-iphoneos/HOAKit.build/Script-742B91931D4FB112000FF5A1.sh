#!/bin/sh
echo "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/"
echo "${SRCROOT}/HOA.xcassets"

TARGET_PATH="${BUILT_PRODUCTS_DIR}/../${PRODUCT_NAME}.bundle"
TARGET_STORYBOARD_FILE="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/*.storyboardc"
TARGET_ASSETS_FILE="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Assets.car"
TARGET_IMAGE_PATH="${SRCROOT}/HOA.xcassets"
TARGET_VENDORS_IMAGE_PATH="${SRCROOT}/Vendors/CTAssetsPickerController/Images.xcassets"

TARGET_JSON_FILE="${SRCROOT}/HOAKit/province.json"
rm -rf ${TARGET_PATH}
rm -rf ${TARGET_ASSETS_FILE}
mkdir ${TARGET_PATH}
mv ${TARGET_STORYBOARD_FILE} ${TARGET_PATH}
cp ${TARGET_JSON_FILE} ${TARGET_PATH}

function scandir() {
    local cur_dir parent_dir workdir cur_file_name
    workdir=$1
    cd ${workdir}
    if [ ${workdir} = "/" ]
    then
    cur_dir=""
    else
    cur_dir=$(pwd)
    fi
    
    for dirlist in $(ls ${cur_dir})
    do
    if test -d ${dirlist};then
        cd ${dirlist}
        scandir ${cur_dir}/${dirlist}
        cd ..
    else
        cur_file_name=${cur_dir}/${dirlist}
        if [[ $cur_file_name =~ \.png$ ]]
        then
            cp ${cur_file_name} ${TARGET_PATH}
        fi
    fi
    done
}

if test -d ${TARGET_IMAGE_PATH}
then
scandir ${TARGET_IMAGE_PATH}
scandir ${TARGET_VENDORS_IMAGE_PATH}
elif test -f ${TARGET_IMAGE_PATH}
then
echo "you input a file but not a directory,pls reinput and try again"
exit 1
else
echo "the Directory isn't exist which you input,pls input a new one!!"
exit 1
fi


