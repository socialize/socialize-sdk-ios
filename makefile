
default:
  # Set default make action here

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	xcodebuild -alltargets -configuration Debug -sdk iphonesimulator clean
test:
	GHUNIT_CLI=1 xcodebuild -target unitTests -configuration Debug -sdk iphonesimulator build
