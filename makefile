
default:
  # Set default make action here

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	xcodebuild -alltargets -configuration Debug -sdk iphonesimulator clean
test:
	WRITE_JUNIT_XML=YES GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build
	xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="542E5F91-FA04-4A6B-BEB8-1CCD67D816FD" CODE_SIGN_IDENTITY="iPhone Distribution: pointabout" clean build
	#xcodebuild -target SampleSdkApp -configuration Debug -sdk iphonesimulator clean build

	mkdir -p "build/SocializeLib"
	lipo -create build/Release-iphoneos/libSocialize.a build/Debug-iphonesimulator/libSocialize.a  -output build/SocializeLib/libSocialize.a
	
	mkdir -p "build/SocializeLib/Headers"
	cp -r build/Release-iphoneos/usr/local/include/  build/SocializeLib/Headers/

	zip -r -u ./build/iosproject.zip ./ --exclude="*build*" --exclude="*.git*" --exclude="*.svn*"