all: c java javascript ruby jruby

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

clean:
	cd c          && make clean
	cd java       && mvn clean
	cd javascript && make clean
	cd ruby       && rake clean

.PHONY: all c java javascript ruby jruby clean
