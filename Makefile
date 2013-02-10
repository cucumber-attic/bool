UNAME := $(shell uname)
RUBY_PLATFORM := $(shell ruby -e "puts RUBY_PLATFORM")
BISON_VERSION := $(shell bison --version | grep ^bison | sed 's/^.* //')
# Keep in sync with c/Makefile
REQUIRED_BISON_VERSION = 2.7
PATH := $(shell pwd)/bison-$(REQUIRED_BISON_VERSION)/tests:$(PATH)
VERSION := $(shell head -1 VERSION)
# http://stackoverflow.com/questions/5694228/sed-in-place-flag-that-works-both-on-mac-and-linux
ifeq ($(UNAME), Darwin)
SEDI = sed -i ''
else
SEDI = sed -i''
endif


all: c javascript ruby winruby jruby

c: bison
	cd c && make

java: bison
	cd java && mvn package

javascript:
	cd javascript && make

ruby: bison
	cd ruby && bundle && bundle exec rake

clangruby: bison
	cd ruby && bundle && CC=clang bundle exec rake clean compile

gccruby: bison
	cd ruby && bundle && CC=gcc bundle exec rake clean compile

jruby: bison
	cd ruby && jruby -S rake

winruby: mingw bison
	cd ruby && bundle && bundle exec rake cross compile

clean:
	cd c          && make clean
	cd java       && mvn clean
	cd javascript && make clean
	cd ruby       && bundle exec rake clean

clobber: clean
	rm -Rf mingw
	rm -Rf javascript/node_modules
	rm -Rf bison-$(REQUIRED_BISON_VERSION)

ifeq ($(UNAME), Darwin)
mingw: mingw/bin/i686-w64-mingw32-gcc

mingw/bin/i686-w64-mingw32-gcc:
	mkdir -p mingw
	# Don't attempt any of the newer versions - they don't work (gcc 4.7.0)
	cd mingw && curl --silent --location http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Automated%20Builds/mingw-w32-1.0-bin_i686-darwin_20110819.tar.bz2 | tar xvj
endif

ifneq ($(BISON_VERSION), $(REQUIRED_BISON_VERSION))
bison: bison-$(REQUIRED_BISON_VERSION)/src/bison

bison-$(REQUIRED_BISON_VERSION)/src/bison:
	curl --silent --location http://ftp.gnu.org/gnu/bison/bison-$(REQUIRED_BISON_VERSION).tar.gz | tar xvz
	cd bison-$(REQUIRED_BISON_VERSION) && ./configure && make
endif

ifeq ($(RUBY_PLATFORM), java)
# ruby is actually jruby. In that case run only the ruby target, which will build with jruby
travis: ruby
else
# ruby is MRI. In that case, build everything. We'll build ruby thrice, once with clang, once with gcc and once with mingw.
travis: c javascript clangruby gccruby winruby
endif

### Bump versions

java/pom.xml: VERSION
	$(SEDI) -e '0,/<version>.*/s//<version>$(VERSION)<\/version>/' java/pom.xml


javascript/package.json: VERSION
	$(SEDI) -e '0,/"version"\s*:.*/s//"version": "$(VERSION)",/' javascript/package.json

ruby/bool.gemspec: VERSION
	$(SEDI) -e '0,/s.version\s*=.*/s//s.version = "$(VERSION)"/' ruby/bool.gemspec

version: java/pom.xml javascript/package.json ruby/bool.gemspec

release: version
	cd javascript && npm publish
	cd ruby && rake release
	cd ruby && RUBY_PLATFORM=x86-mingw32 rake release
	cd ruby && jruby -S rake release
	cd java && mvn clean source:jar javadoc:jar deploy
	echo "**********************************************"
	echo "go to https://oss.sonatype.org/"
	echo "then CLOSE and RELEASE (no description needed)"
	echo "**********************************************"

.PHONY: all c java javascript ruby clangruby gccruby jruby winruby mingw travis bison clean

