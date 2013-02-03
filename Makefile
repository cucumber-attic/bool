UNAME := $(shell uname)
PATH := $(shell pwd)/mingw/bin:$(PATH)
RUBY_PLATFORM := $(shell ruby -e "puts RUBY_PLATFORM")

all:    c javascript ruby winruby jruby

c: 
	cd c && make

java:
	cd java && mvn package

javascript:
	cd javascript && make

ruby:
	cd ruby && rake

jruby:
	cd ruby && jruby -S rake

winruby: mingw
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
	cd mingw && curl -sL http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Automated%20Builds/mingw-w32-1.0-bin_i686-darwin_20110819.tar.bz2 | tar xvj
endif

ifeq ($(RUBY_PLATFORM), java)
travis: ruby
else
travis: c javascript ruby winruby
endif

.PHONY: all c java javascript ruby jruby winruby mingw clean
