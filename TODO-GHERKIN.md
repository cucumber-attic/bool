## TODO

- [x] empty scenario/background name
- [x] aligned table cells
- [x] aligned table cells with numbers(right)/text(left)
- [x] no description
- [x] Tags
- [x] keywords after keywords
- [x] Stack frames from Scenario Outline
- [x] Stack frames from Background
- [x] All tokens should have location info. Good cross platform tests for this!
- [x] Descriptionlines should be tokens. Everything should be!
- [x] Scenario Outline compilation: replace <tokens> in DocStrings.
- [x] Scenario Outline compilation: replace <tokens> in DataTables.
- [ ] Ignore # comments
- [ ] Test with tabs: Feature:\tname
- [ ] Test with no space: Feature:name
- [ ] Feature/Scenario/Step name not ending with newline before EOF
- [ ] Test with all of \r, \r\n and \n (CRLF)
- [ ] Verify that internal indentation gets preserved through parser->renderer, both for descriptions and DocStrings.

    Feature: Foo
      h1. This is a description

      1. bullet
        1. sub bullet

- [x] Tags on Examples. Currently causing conflicts compiling the parser.
- [ ] Allow more than a single Examples under Scenario Outline. See TODO in parser.y
- [ ] DocStrings and descriptions: Must verify in unit test that the AST nodes strip away indentation left of first line start
- [ ] Lex/parse DocStrings and descriptions in a more similar fashion. 
      Perhaps line by line is simpler and will solve hanging regexp bug?
- [ ] Scenario Outline with step args not present in table header cells should fail
- [ ] Scenario Outline with table args not present in outline steps should fail
- [ ] Verify that Examples without table fails
- [ ] Verify that Examples with table containing only header fails
- [ ] Add back-references in compiled nodes (might not be necessary)
- [ ] Consider internal iteration for visitors. It might simplify the code a lot since visitors won't need to iterate.
- [ ] Implement tag/line/name filters.
- [ ] API docs for compiler output structure, essentially attributes and location info.

## Bugs
- [x] Scenario Outline after DocString causes lexer to hang on regexp match.
- [x] Table with trailing space crashes
