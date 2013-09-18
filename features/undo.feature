Feature: undo
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    Given a file named "examples/step_definitions/extra.rb" with:
      """
      When(/I do some magical stuff with '(\w+)'/) do |*args|
        # just example
      end

      """
    Given a file named "examples/undo.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          Then I will write new steps

      """

  Scenario: no undo available
    When I run `cucumber examples/undo.feature` interactively
    And I type "undo"
    And I type "exit"
    Then it should pass with:
      """
      There's nothing to revert yet
      """

  Scenario: simple undo
    When I run `cucumber examples/undo.feature` interactively
    And I type "When I do some magical stuff with 'water'"
    And I type "undo"
    And I type "exit"
    Then it should pass with:
      """
      Saved `When I do some magical stuff with 'water'` to undo.feature
      """
    And it should pass with:
      """
      Removed `When I do some magical stuff with 'water'` from undo.feature
      """
    And the file "examples/undo.feature" should contain exactly:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          Then I will write new steps

      """

  Scenario: multiple undo
    When I run `cucumber examples/undo.feature` interactively
    And I type "When I do some magical stuff with 'water'"
    And I type "When I do some magical stuff with 'fire'"
    And I type "undo"
    And I type "undo"
    And I type "undo"
    And I type "exit"
    Then it should pass with:
      """
      Saved `When I do some magical stuff with 'water'` to undo.feature
      """
    And it should pass with:
      """
      Saved `When I do some magical stuff with 'fire'` to undo.feature
      """
    And it should pass with:
      """
      Removed `When I do some magical stuff with 'water'` from undo.feature
      """
    And it should pass with:
      """
      Removed `When I do some magical stuff with 'fire'` from undo.feature
      """
    And it should pass with:
      """
      There's nothing to revert yet
      """
    And the file "examples/undo.feature" should contain exactly:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          Then I will write new steps

      """