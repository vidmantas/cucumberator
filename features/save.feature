Feature: step saving
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

  Scenario: autosave after successfull execution
    Given a file named "examples/autosave.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          Then I will write new steps

      """
    When I run `cucumber examples/autosave.feature` interactively
    And I type "When I do some magical stuff with 'chairs'"
    And I type "exit"
    Then it should pass with:
      """
      Saved `When I do some magical stuff with 'chairs'` to autosave.feature
      """
    And the file "examples/autosave.feature" should contain exactly:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          When I do some magical stuff with 'chairs'
          Then I will write new steps

      """