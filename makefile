.PHONY: tags framework bundle integration-tests ui-integration-tests clean test

BUNDLE_SCHEME=Socialize Bundle

CLEAN_SCHEMES = unitTests SampleSdkApp UIIntegrationTests IntegrationTests "Socialize Framework"

default: build buildsample test package
 	# do all the dependencies above
	#
package: framework
    # zip sources
	./util/package.sh
     
framework:
  	# build embedded framework
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "Socialize Framework" -configuration Release -sdk iphoneos build

bundle:
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "${BUNDLE_SCHEME}" -configuration Release -sdk iphoneos build
	mkdir -p build/Socialize.bundle
	cp -R build/Socialize-iphoneos.bundle/. build/Socialize.bundle

buildsample:
	#building sample
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "Socialize Framework" -configuration Release -sdk iphoneos build	
	#xcodebuild -target SampleSdkApp -configuration Distribution -sdk iphoneos PROVISIONING_PROFILE="542E5F91-FA04-4A6B-BEB8-1CCD67D816FD" CODE_SIGN_IDENTITY="iPhone Distribution: pointabout" build
     
# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "Socialize" -configuration Release -sdk iphoneos clean
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "unitTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -workspace SampleSdkApp/SampleSdkApp.xcworkspace -scheme "IntegrationTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -workspace SampleSdkApp/SampleSdkApp.xcworkspace -scheme "IntegrationTests" -configuration Debug -sdk iphonesimulator clean
	rm -rfd build
	rm -f $(SUBST_BUILD_FILES)

test:
	WRITE_JUNIT_XML=YES RUN_CLI=YES xcodebuild -workspace socialize-sdk-ios.xcworkspace/ -sdk iphonesimulator -configuration Debug -scheme unitTests
	#WRITE_JUNIT_XML=YES GHUNIT_UI_CLI=1 xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme unitTests -configuration Debug -sdk iphonesimulator build

integration-tests:
	cd SampleSdkApp && WRITE_JUNIT_XML=YES RUN_CLI=1 xcodebuild -workspace SampleSdkApp.xcworkspace/ -scheme IntegrationTests -configuration Debug -sdk iphonesimulator build

ui-integration-tests:
	cd SampleSdkApp && RUN_CLI=1 xcodebuild -workspace SampleSdkApp.xcworkspace/ -scheme UIIntegrationTests -configuration Debug -sdk iphonesimulator build

doc:
	cd "./Socialize";\
	ls; \
	appledoc ./DocSettings.plist
mytest:
	xcodebuild -project SocializeSDK.xcodeproj -target "Socialize Framework" -configuration Distribution -sdk iphoneos clean build
	WRITE_JUNIT_XML=YES GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build

sphinx_doc: subst-build
	export LANG=en_US.UTF-8;\
	export LC_ALL=en_US.UTF-8;\
	export LC_CTYPE=en_US.UTF-8;\
	ant -buildfile ./sphinx_doc.xml

build-sample-debug:
	xcodebuild -workspace socialize-sdk-ios.xcworkspace -scheme "SampleSdkApp" -configuration Debug -sdk iphonesimulator build	

tags:
	ctags -R --language-force=ObjectiveC --extra=f Socialize SampleSdkApp Frameworks


debug: build-sample-debug
	./debug.sh

-include subst.mk

SUBST_BUILD_FILES := Socialize/Classes/SocializeVersion.h Documentation/sphinx/source/conf.py

subst-build: $(SUBST_BUILD_FILES)
