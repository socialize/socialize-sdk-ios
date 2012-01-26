.SUFFIXES:

SOCIALIZE_VERSION=$(shell cat version)

%: %.in version
	sed \
		-e "s^@socialize_version\@^$(SOCIALIZE_VERSION)^g" \
		< $< > $@ || rm $@
