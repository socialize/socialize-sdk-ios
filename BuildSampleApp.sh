#!/bin/sh


if [ "${BUILD_STYLE}" == "Distribution" ]; then

mkdir -p "$BUILD_DIR/test-appzipped/"
mkdir -p "$BUILD_DIR/test-appzipped/Binary"
mkdir Payload

cp -r "$BUILD_DIR"/Distribution-iphoneos/ Payload/

zip -r "$BUILD_DIR/test-appzipped/Binary"/SampleSdkApp.app.dSYM.zip Payload/SampleSdkApp.app.dSYM

rm -rf Payload/SampleSdkApp.app.dSYM
cp -f "${PROJECT_DIR}"/Icon.png iTunesArtwork
zip -r "$BUILD_DIR/test-appzipped/"/SampleSdkApp.ipa Payload iTunesArtwork

mv "$BUILD_DIR/test-appzipped/"/SampleSdkApp.ipa "$BUILD_DIR/test-appzipped/Binary"/

rm -rf iTunesArtwork
rm -rf Payload

else

mkdir -p "$BUILD_DIR/test-appzipped/"
mkdir -p "$BUILD_DIR/test-appzipped/Binary"
mkdir Payload

cp -r "$BUILD_DIR"/Debug-iphonesimulator/ Payload/

zip -r "$BUILD_DIR/test-appzipped/Binary"/SampleSdkApp.app.dSYM.zip Payload/SampleSdkApp.app.dSYM

rm -rf Payload/SampleSdkApp.app.dSYM
cp -f "${PROJECT_DIR}"/Icon.png iTunesArtwork
zip -r "$BUILD_DIR/test-appzipped/"/SampleSdkApp.ipa Payload iTunesArtwork

mv "$BUILD_DIR/test-appzipped/"/SampleSdkApp.ipa "$BUILD_DIR/test-appzipped/Binary"/

rm -rf iTunesArtwork
rm -rf Payload

fi