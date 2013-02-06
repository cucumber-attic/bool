UNAME := $(shell uname)
RUBY_PLATFORM := $(shell ruby -e "puts RUBY_PLATFORM")
BISON_VERSION := $(shell bison --version | grep ^bison | sed 's/^.* //')
# Keep in sync with c/Makefile
REQUIRED_BISON_VERSION = 2.7
PATH := $(shell pwd)/bison-$(REQUIRED_BISON_VERSION)/tests:$(PATH)

all: c javascript ruby winruby jruby

c: bison
	cd c && make

java: bison
	cd java && mvn package

javascript:
	cd javascript && make

ruby: bison
	cd ruby && rake

clangruby: bison
	cd ruby && CC=clang rake clean compile

gccruby: bison
	cd ruby && CC=gcc rake clean compile

jruby: bison
	cd ruby && jruby -S rake

winruby: mingw bison
	cd ruby && rake cross compile

clean:
	cd c          && make clean
	cd java       && mvn clean
	cd javascript && make clean
	cd ruby       && rake clean

clobber: clean
	rm -Rf mingw

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
travis: ruby
else
travis: c javascript clangruby gccruby winruby
endif

.PHONY: all c java javascript ruby clangruby gccruby jruby winruby mingw travis bison clean

