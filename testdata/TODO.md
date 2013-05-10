# TODO

[x] empty scenario/background name
[x] aligned table cells
[x] aligned table cells with numbers(right)/text(left)
[x] no description
[ ] table with trailing space
[ ] description with internal indentation (markdown)
[x] keywords after keywords
[ ] Examples without table
[ ] Examples with table containing only header
[ ] Scenario Outline with step args not in table
[ ] Scenario Outline with table args not in step
[x] Stack frames from Scenario Outline
[x] Stack frames from Background
[ ] Back references in compiled nodes
[ ] DocStrings and descriptions: Must verify in unit test that the AST nodes strip away indentation left of first line start
[ ] Lex/parse DocStrings and Descriptions in a more similar fashion. Perhaps line by line is simpler and will solve hanging regexp problem?
[ ] comments
[ ] Consider internal iteration for visitors. Do this after writing the compiler. It might simplify the code a lot.
[x] Tags
[ ] Filters
[x] All tokens should have location info. Good cross platform tests for this!
[x] Descriptionlines should be tokens. Everything should be!
[ ] Scenario Outline after DocString causes lexer to hang on regexp match. See example below.
[ ] API docs for compiler output, essentially attributes and location info.

### Infinite loop!
'\n      Look\n      Ma\n      DocString\n      """\n\n  Scenario Outline: World\n    Given I have <m> cukes (<m>) in my belly\n    When I eat <m> cukes\n    Then I should have <n> cukes in my belly\n\n    Examples: a few\n      | m   | n   |\n      |   1 |   2 |\n      |  20 |  40 |\n      | 300 | 600 |\n'
---
/^(?:(.|\s)+(?=\n\s*"""))/
