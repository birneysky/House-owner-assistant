#!/bin/bash
# build_ios_libs.sh
# set the vars
CONFIG="Debug"
ARG="Debug"
SIMULATORSDK="iphonesimulator"
IPHONESDK="iphoneos"
while getopts ":c:v:" OPTION
do
    case $OPTION in
        c)
            ARG=$OPTARG
            ;;
        v)
            SIMULATORSDK=${SIMULATORSDK}${OPTARG}
            IPHONESDK=${IPHONESDK}${OPTARG}
            ;;
        ?)echo "error options,not support. please use \"-c\""
            exit 1;;
    esac
done

echo "sdks:  $SIMULATORSDK,$IPHONESDK"

if [ "$ARG" = "Release" -o "$ARG" = "Debug" ];then
    CONFIG=$ARG
    echo "configuration is $CONFIG"
else
    exit 1
fi

xcodebuild clean -project HOAKit/HOAKit.xcodeproj -sdk $SIMULATORSDK -configuration $CONFIG
xcodebuild  -project HOAKit/HOAKit.xcodeproj -sdk $SIMULATORSDK -configuration $CONFIG
if [[ $? -eq 0 ]];then
    echo ""
else
    echo "simulator ${PATHSARRAY[i]} build failed"
    exit 1
fi

rm -rf HOAKit.bundle

xcodebuild clean -project HOAKit/HOAKit.xcodeproj -sdk $IPHONESDK -configuration $CONFIG
xcodebuild -project HOAKit/HOAKit.xcodeproj -sdk $IPHONESDK -configuration $CONFIG
if [[ $? -eq 0 ]];then
    echo ""
else
    echo "simulator ${PATHSARRAY[i]} build failed"
    exit 1
fi


cd ../../source_house/g_ios/

svn up

svn rm HOAKit.bundle
svn rm HOAKit-iphoneos/HOAKit.framework/
svn rm HOAKit-iphonesimulator/HOAKit.framework/

svn commit -m "delete kit"

cp -r  ../../source_git/House-owner-assistant/HOAKit.bundle ./
cp -r ../../source_git/House-owner-assistant/HOAKit-iphoneos/HOAKit.framework ./HOAKit-iphoneos/
cp -r ../../source_git/House-owner-assistant/HOAKit-iphonesimulator/HOAKit.framework ./HOAKit-iphonesimulator/


svn add HOAKit.bundle
svn add HOAKit-iphoneos/HOAKit.framework/
svn add HOAKit-iphonesimulator/HOAKit.framework/

svn commit -m "add kit"




