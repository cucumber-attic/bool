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
[ ] Stack frames from Scenario Outline
[ ] Stack frames from Background
[ ] Back references in compiled nodes
[ ] Must verify in unit test that the AST nodes strip away indentation left of first line start
[ ] comments
[ ] Consider internal iteration for visitors. Do this after writing the compiler. It might simplify the code a lot.
[ ] Tags
[ ] Filters
[ ] All tokens should have location info. Good cross platform tests for this!
[ ] Descriptionlines should be tokens. Everything should be!


### Infinite loop!
'\n      Look\n      Ma\n      DocString\n      """\n\n  Scenario Outline: World\n    Given I have <m> cukes (<m>) in my belly\n    When I eat <m> cukes\n    Then I should have <n> cukes in my belly\n\n    Examples: a few\n      | m   | n   |\n      |   1 |   2 |\n      |  20 |  40 |\n      | 300 | 600 |\n'
---
/^(?:(.|\s)+(?=\n\s*"""))/
