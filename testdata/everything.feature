Feature: Hello

  Background: yo
    Given I have 10 cukes in my belly

  Scenario: World
    Given I have 3 more cukes in my belly
    When I have 3 cukes in my belly
      |foo|bar|
      |xxx|yyy|
    When I have 3 cukes in my belly
      """
      Look
      Ma
      DocString
      """
