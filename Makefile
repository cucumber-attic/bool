UNAME := $(shell uname)
VERSION := $(shell head -1 VERSION)
RUBY_PLATFORM := $(shell ruby -e "puts RUBY_PLATFORM")

all: c javascript ruby winruby jruby

c:
	cd c && make

java:
	cd java && mvn package

javascript:
	cd javascript && make

ruby:
	cd ruby && bundle && bundle exec rake

clangruby:
	cd ruby && bundle && CC=clang bundle exec rake clean compile

gccruby:
	cd ruby && bundle && CC=gcc bundle exec rake clean compile

jruby:
	cd ruby && jruby -S rake

winruby: mingw
	cd ruby && bundle && bundle exec rake cross compile

clean:
	cd c          && make clean
	cd java       && mvn clean
	cd javascript && make clean
	cd ruby       && bundle exec rake clean

clobber:
	git clean -dfx

ifeq ($(UNAME), Darwin)
mingw: mingw/bin/i686-w64-mingw32-gcc

mingw/bin/i686-w64-mingw32-gcc:
	mkdir -p mingw
	cd mingw && curl --silent --location http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Automated%20Builds/mingw-w32-1.0-bin_i686-darwin_20130531.tar.bz2 | tar xvj
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
	@echo "*************************************************************"
	@echo "Release successful!                                          "
	@echo "Go to https://oss.sonatype.org/index.html#stagingRepositories"
	@echo "then CLOSE and RELEASE (no description needed)               "
	@echo "*************************************************************"

.PHONY: all c java javascript ruby clangruby gccruby jruby winruby mingw travis bison not_dirty clean version

