@foo
Feature: Hello
  The description is really really long
  x

  Background: yo
    Given I have 10 cukes in my belly

  @bar
  Scenario: Scenario:
    Given I have 3 more cukes in my belly
    When I have 3 cukes in my belly
      | foo | bar |
      | xxx | yyy |
    When I have 3 cukes in my belly
      """
      Look
      Ma
      DocString
      """

  @snip @snap
  Scenario Outline: World
    Given I have <m> cukes (<m>) in my belly
    When I eat <m> cukes
    Then I should have <n> cukes in my belly

    Examples: a few
      | m   | n   |
      |   1 |   2 |
      |  20 |  40 |
      | 300 | 600 |
