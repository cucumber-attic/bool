NODE_VERSION_LT_0_8 := $(shell node -e "console.log(process.version.match(/^v0\.[1-7]/) != null)")

ifeq ($(NODE_VERSION_LT_0_8),true)
$(error Bad node version. Please install v0.8.11 or higher. You have node $(shell node --version))
endif

all: mocha

mocha: node_modules lib/parser.js
	@NODE_PATH=lib ./node_modules/.bin/mocha
.PHONY: mocha

clean:
	rm -f lib/parser.js
.PHONY: clean

clobber:
	git clean -dfx
.PHONY: clobber

lib/parser.js: lib/parser.jison lib/lexer.jisonlex node_modules
	./node_modules/.bin/jison -o $@ lib/parser.jison lib/lexer.jisonlex

node_modules: package.json
	npm install
	touch $@

