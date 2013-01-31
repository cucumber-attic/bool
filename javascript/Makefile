VERSION := $(shell node -e "console.log(JSON.parse(require('fs').readFileSync('package.json', 'utf8')).version)")

all: mocha

mocha: node_modules lib/bool/parser.js
	@NODE_PATH=lib ./node_modules/.bin/mocha
.PHONY: mocha

clean:
	rm -f lib/bool/parser.js
.PHONY: clean

clobber:
	git clean -dfx
.PHONY: clobber

lib/bool/parser.js: lib/bool/parser.jison lib/bool/lexer.jisonlex node_modules
	./node_modules/.bin/jison -o $@ lib/bool/parser.jison lib/bool/lexer.jisonlex

publish: lib/bool/parser.js
	npm publish && git tag v$(VERSION) -m "Release v$(VERSION)" && git push && git push --tags
.PHONY: publish

node_modules: package.json
	npm install
	touch $@

