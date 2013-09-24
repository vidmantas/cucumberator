Feature: save command
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    Given a file named "examples/save.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          Then I will write new steps

      """

  Scenario: check `save` command
    When I run `cucumber examples/save.feature` interactively
    And I type "When I do something extraordinary"
    And I type "save"
    And I type "exit"
    Then it should pass with:
      """
      Saved `When I do something extraordinary` to save.feature
      """
    And the file "examples/save.feature" should contain exactly:
      """
      Feature: example
        Scenario: stop where exit
          When I do something extraordinary
          Then I will write new steps

      """
