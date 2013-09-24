Feature: save empty line
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
    Given a file named "examples/empty_nl.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'
          Then I will write new steps

      """

  Scenario: check if empty line is saved
    When I run `cucumber examples/empty_nl.feature` interactively
    And I type ""
    And I type "exit"
    Then it should pass with:
      """
      1 scenario (1 passed)
      """
    And the file "examples/empty_nl.feature" should contain exactly:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with 'apples'

          Then I will write new steps

      """
