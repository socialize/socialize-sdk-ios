
default:
  # Set default make action here

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	xcodebuild -alltargets -configuration Debug -sdk iphonesimulator clean
	xcodebuild -alltargets -configuration Distribution -sdk iphoneos clean
	rm -rfd build
test:
# build embedded framework
	xcodebuild -target Socialize-iOS -configuration Distribution -sdk iphoneos clean build	

# run unit tests
	WRITE_JUNIT_XML=YES GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build

# build sample application
	xcodebuild -target Socialize-iOS -configuration Distribution -sdk iphoneos clean build	
	#xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="542E5F91-FA04-4A6B-BEB8-1CCD67D816FD" CODE_SIGN_IDENTITY="iPhone Distribution: pointabout" build

# zip sources
	cp -r ./build/Socialize-iOS.embeddedframework ./ 
	zip -r -u ./build/iosproject.zip ./ --exclude="*build*" --exclude="*.git*" --exclude="*.svn*"

doc:
	cd "./Socialize";\
	ls; \
	appledoc ./DocSettings.plist
	cp -r ./Documentation/GettingStartedGuide/images/ ./Documentation/html/images/
mytest:
	xcodebuild -target Socialize-iOS -configuration Distribution -sdk iphoneos clean build
	WRITE_JUNIT_XML=YES GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build
