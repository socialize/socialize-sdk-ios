#!/bin/sh
BUILD_DIR="./build"
ZIP_FILE="../socialize_ios.zip"
PACKAGE_DIR="${BUILD_DIR}/package_dir"
EMBEDDED_FRAMEWORK="./build/Socialize.embeddedframework"

if [ -e $PACKAGE_DIR ]
then
    rm -R $PACKAGE_DIR
fi
mkdir $PACKAGE_DIR

#the -R parameter makes sure we dont follow symbolic link, increasing package size
cp -R $EMBEDDED_FRAMEWORK $PACKAGE_DIR
cp ./Documentation/read_me_first.html $PACKAGE_DIR/

cd $PACKAGE_DIR
if [ -f $ZIP_FILE ];\
then
    rm $ZIP_FILE
fi  
zip -ry $ZIP_FILE ./*  --exclude="*.git*" --exclude="*.svn*"
