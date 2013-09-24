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
    Given a file named "examples/cucumberize.feature" with:
      """
      Feature: example
        @cucumberize
        Scenario: cucumberize
          When I do some magical stuff with 'apples'

      """

  Scenario: autosave after successfull execution
    When I run `cucumber examples/cucumberize.feature` interactively
    And I type "When I do some magical stuff with 'chairs'"
    And I type "exit"
    Then it should pass with:
      """
      Saved `When I do some magical stuff with 'chairs'` to cucumberize.feature
      """
    And the file "examples/cucumberize.feature" should contain exactly:
      """
      Feature: example
        @cucumberize
        Scenario: cucumberize
          When I do some magical stuff with 'apples'
          When I do some magical stuff with 'chairs'

      """
