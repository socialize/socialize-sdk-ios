.PHONY: tags framework bundle integration-tests ui-integration-tests clean test package release

test:
	WRITE_JUNIT_XML=YES RUN_CLI=1 xcodebuild -scheme UnitTests -configuration Debug -sdk iphonesimulator

default: build buildsample test package

package: framework
	./Scripts/package.sh

release: package
     
framework:
	xcodebuild -scheme "Socialize Framework" -configuration Release

clean:
	xcodebuild -scheme "Socialize" -configuration Release -sdk iphoneos clean
	xcodebuild -scheme "UnitTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -scheme "IntegrationTests" -configuration Debug -sdk iphonesimulator clean
	xcodebuild -scheme "UIIntegrationTests" -configuration Debug -sdk iphonesimulator clean
	rm -rfd build
	rm -f $(SUBST_BUILD_FILES)

coverage:
	./Scripts/generate-combined-coverage-report.sh build/test-coverage/UIIntegrationTests-Coverage.info build/test-coverage/IntegrationTests-Coverage.info build/test-coverage/unitTests-Coverage.info

integration-tests:
	WRITE_JUNIT_XML=YES RUN_CLI=1 xcodebuild -scheme IntegrationTests -configuration Debug -sdk iphonesimulator build

ui-integration-tests:
	RUN_CLI=1 xcodebuild -scheme UIIntegrationTests -configuration Debug -sdk iphonesimulator build

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

