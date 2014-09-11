.PHONY: tags framework bundle integration-tests ui-integration-tests clean test package release

pods:
	pod install

test:
	SZEventTrackingDisabled=1 WRITE_JUNIT_XML=YES RUN_CLI=1 GHUNIT_CLI=1 xcodebuild -workspace Socialize.xcworkspace -scheme UnitTests -configuration Debug -sdk iphonesimulator -destination OS=7.1,name="iPhone 5"

default: build buildsample test package

package: framework
	./Scripts/package.sh

release: package
     
framework:
	xcodebuild -workspace Socialize.xcworkspace -scheme "Socialize Framework" -configuration Release

clean:
	xcodebuild -workspace Socialize.xcworkspace -scheme "Socialize" -configuration Release -sdk iphoneos clean
	xcodebuild -workspace Socialize.xcworkspace -scheme "UnitTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -workspace Socialize.xcworkspace -scheme "IntegrationTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -workspace Socialize.xcworkspace -scheme "TestApp" -configuration Debug -sdk iphonesimulator clean
	rm -rfd build
	rm -f $(SUBST_BUILD_FILES)

coverage:
	./Scripts/generate-combined-coverage-report.sh build/test-coverage/IntegrationTests-Coverage.info build/test-coverage/unitTests-Coverage.info build/test-coverage/UIIntegrationTests-Coverage.info

integration-tests:
	WRITE_JUNIT_XML=YES RUN_CLI=1 xcodebuild -workspace Socialize.xcworkspace -scheme IntegrationTests -configuration Debug -sdk iphonesimulator -destination OS=7.1,name="iPhone 5" build

ui-integration-tests:
	xcodebuild -workspace Socialize.xcworkspace -scheme "TestApp" -configuration Debug -sdk iphonesimulator -destination OS=7.1,name="iPhone 5" test
	./Scripts/generate-ui-coverage-report.sh

doc:
	cd Socialize && appledoc ./DocSettings.plist

.SUFFIXES:

-include subst.mk
SUBST_BUILD_FILES := Socialize-noarc/SocializeVersion.h Documentation/sphinx/source/conf.py
subst: $(SUBST_BUILD_FILES)

sphinx_doc: subst
	export LANG=en_US.UTF-8;\
	export LC_ALL=en_US.UTF-8;\
	export LC_CTYPE=en_US.UTF-8;\
	ant -buildfile ./sphinx_doc.xml

tags:
	ctags -R --language-force=ObjectiveC --extra=f Socialize SampleSdkApp Frameworks

ci:
	make pods
	make clean
	make test
	make integration-tests
	make coverage
