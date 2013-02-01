VERSION := $(shell node -e "console.log(JSON.parse(require('fs').readFileSync('package.json', 'utf8')).version)")

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

publish: lib/parser.js
	npm publish && git tag v$(VERSION) -m "Release v$(VERSION)" && git push && git push --tags
.PHONY: publish

node_modules: package.json
	npm install
	touch $@

