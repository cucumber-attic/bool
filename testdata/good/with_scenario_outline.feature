Feature: Hello

  Background: b
    Given a background <n> step

  @foo
  Scenario Outline: World
    Given I have <m> cukes (<m>) in my belly
      """
      A doc
      string <n> gets
      variables <m> replaced
      """
    When I eat <m> cukes
    Then I should have <n> cukes in my belly

    Examples: a few
      | m   | n   |
      |   1 |   2 |
      |  20 |  40 |
      | 300 | 600 |
