Feature: step saving
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """

  Scenario: last-step display
    Given a file named "examples/autosave_explicit.feature" with:
      """
      Feature: example
        Scenario: example
          Then I will write new steps

      """
    When I run `cucumber examples/autosave_explicit.feature` interactively
    And I type "When new step is executed"
    And I type "last-step"
    And I type "exit"
    Then it should pass with:
      """
      When new step is executed
      """