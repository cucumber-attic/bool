UNAME := $(shell uname)
VERSION := $(shell head -1 VERSION)
RUBY_PLATFORM := $(shell ruby -e "puts RUBY_PLATFORM")
# Keep in sync with c/Makefile
REQUIRED_BISON_VERSION = 2.7
REQUIRED_FLEX_VERSION = 2.5.37
BISON_VERSION := $(shell bison --version | grep ^bison | sed 's/^.* //')
FLEX_VERSION := $(shell flex --version | cut -d' ' -f2)

all: c javascript ruby winruby jruby

c: flex bison
	cd c && make

java: flex bison
	cd java && mvn package

javascript:
	cd javascript && make

ruby: flex bison
	cd ruby && bundle && bundle exec rake

clangruby: flex bison
	cd ruby && bundle && CC=clang bundle exec rake clean compile

gccruby: flex bison
	cd ruby && bundle && CC=gcc bundle exec rake clean compile

jruby: bison
	cd ruby && jruby -S rake

winruby: mingw flex bison
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
	rm -Rf flex-$(REQUIRED_FLEX_VERSION)

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

ifneq ($(FLEX_VERSION), $(REQUIRED_FLEX_VERSION))
flex: flex-$(REQUIRED_FLEX_VERSION)

flex-$(REQUIRED_FLEX_VERSION):
	curl --silent --location http://prdownloads.sourceforge.net/flex/flex-$(REQUIRED_FLEX_VERSION).tar.gz?download | tar xvz
	cd flex-$(REQUIRED_FLEX_VERSION) && ./configure && make
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
	perl -i -pe 'if (!$$changed) {s/<version>.*/<version>$(VERSION)<\/version>/ and $$changed++;}' java/pom.xml

javascript/package.json: VERSION
	perl -i -pe 'if (!$$changed) {s/"version"\s*:.*/"version": "$(VERSION)",/ and $$changed++;}' javascript/package.json

ruby/bool.gemspec: VERSION
	perl -i -pe 'if (!$$changed) {s/s.version\s*=.*/s.version = "$(VERSION)"/ and $$changed++;}' ruby/bool.gemspec

version: java/pom.xml javascript/package.json ruby/bool.gemspec

release: clean version all
	cd javascript && npm publish
	cd ruby && rake release
	cd ruby && RUBY_PLATFORM=x86-mingw32 rake release
	cd ruby && RUBY_PLATFORM=java rake release
	cd java && mvn -Psign clean source:jar javadoc:jar deploy
	@echo "**********************************************"
	@echo "go to https://oss.sonatype.org/"
	@echo "then CLOSE and RELEASE (no description needed)"
	@echo "**********************************************"

.PHONY: all c java javascript ruby clangruby gccruby jruby winruby mingw travis bison not_dirty clean version

