.PHONY: blockskit jsonkit facebook

# make PREFIX=ABC123 install
# output goes in lib, include

PREFIX ?=
DESTDIR ?= ./
CONFIGURATION ?= Release
SDK ?= iphonesimulator
BUILDDIR := build/$(CONFIGURATION)-$(SDK)
LIBS := \
	BlocksKit/$(BUILDDIR)/libBlocksKit.a \
	JSONKit/$(BUILDDIR)/libJSONKit.a \
	OAuthConsumer/$(BUILDDIR)/libOAuthConsumer.a \
	facebook-ios-sdk/src/$(BUILDDIR)/libfacebook_ios_sdk.a

HEADERS := \
	BlocksKit/$(BUILDDIR)/BlocksKit \
	JSONKit/$(BUILDDIR)/JSONKit \
	OAuthConsumer/$(BUILDDIR)/OAuthConsumer \
	facebook-ios-sdk/src/$(BUILDDIR)/FBConnect

XCODEBUILD := xcodebuild -sdk $(SDK) -configuration $(CONFIGURATION)

all: blockskit jsonkit facebook oauth

install: all
	mkdir -p "$(DESTDIR)/lib"
	mkdir -p "$(DESTDIR)/include"
	cp $(LIBS) "$(DESTDIR)/lib"
	cp -R $(HEADERS) "$(DESTDIR)/include"

clean:
	cd BlocksKit && $(XCODEBUILD) clean -alltargets
	cd JSONKit && $(XCODEBUILD) clean -alltargets
	cd OAuthConsumer && $(XCODEBUILD) clean -alltargets
	cd facebook-ios-sdk/src && $(XCODEBUILD) clean -alltargets

blockskit:
	cd BlocksKit && $(XCODEBUILD) -target "iOS Library" GCC_PREPROCESSOR_DEFINITIONS="BKPREFIX=$(PREFIX)"

jsonkit:
	cd JSONKit && $(XCODEBUILD) -target "JSONKit" GCC_PREPROCESSOR_DEFINITIONS="JKPREFIX=$(PREFIX)"

facebook:
	cd facebook-ios-sdk/src && $(XCODEBUILD) -target "facebook-ios-sdk" GCC_PREPROCESSOR_DEFINITIONS="FBPREFIX=$(PREFIX)"

oauth:
	cd OAuthConsumer && $(XCODEBUILD) -target "OAuthConsumer iOS" GCC_PREPROCESSOR_DEFINITIONS="OAPREFIX=$(PREFIX)"
