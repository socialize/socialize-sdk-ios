
default: build buildsample test package
 	# do all the dependencies above
	#
package: build
    # zip sources
	./util/package.sh
     
build: 
  	# build embedded framework
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme Socialize-iOS -configuration Distribution -sdk iphoneos build

buildsample:
	#building sample
	xcodebuild -workspace socialize-sdk-ios.xcworkspacei -scheme Socialize-iOS -configuration Distribution -sdk iphoneos build	
	#xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="542E5F91-FA04-4A6B-BEB8-1CCD67D816FD" CODE_SIGN_IDENTITY="iPhone Distribution: pointabout" build
     
# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	xcodebuild -project SocializeSDK.xcodeproj -alltargets -configuration Debug -sdk iphonesimulator clean
	xcodebuild -project SocializeSDK.xcodeproj -alltargets -configuration Distribution -sdk iphoneos clean
	rm -rfd build
test: build
# run unit tests
	WRITE_JUNIT_XML=YES GHUNIT_UI_CLI=1 xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme unitTests -configuration Debug -sdk iphonesimulator build

integration-tests:
	./util/run-integration-tests.sh

doc:
	cd "./Socialize";\
	ls; \
	appledoc ./DocSettings.plist
mytest:
	xcodebuild -project SocializeSDK.xcodeproj -target Socialize-iOS -configuration Distribution -sdk iphoneos clean build
	WRITE_JUNIT_XML=YES GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build

sphinx_doc:
	export LANG=en_US.UTF-8;\
	export LC_ALL=en_US.UTF-8;\
	export LC_CTYPE=en_US.UTF-8;\
	ant -buildfile ./sphinx_doc.xml
