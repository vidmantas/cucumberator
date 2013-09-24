Feature: steps command
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
    Given a file named "examples/steps.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          Then I will write new steps

      """

  Scenario: check `steps` command
    When I run `cucumber examples/steps.feature` interactively
    And I type "steps"
    And I type "exit"
    Then it should pass with:
      """
      :: Yay, you have 2 steps in your pocket:
      /^I will write new steps$/
      /I do some magical stuff with '(\w+)'/
      """
