Feature: it should display the code around
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    Given a file named "examples/step_definitions/extra.rb" with:
      """
      When(/I do some magical stuff with "(\w+)"/) do |*args|
        # just example
      end
      """

  Scenario: display code for simple scenario
    Given a file named "examples/where.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          Then I will write new steps

      """
    When I run `cucumber examples/where.feature` interactively
    And I type "where"
    And I type "exit"
    Then it should pass with:
      """
      2:      Scenario: stop where exit
      """
    And the output should contain "3: ->     Then I will write new steps"
    And the output should contain "4:"

  Scenario: display code for larger scenario
    Given a file named "examples/where_bigger.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          When I do some magical stuff with "apples"
          And I do some magical stuff with "oranges"
          And I do some magical stuff with "raspberries"
          Then I will write new steps
          And I do some magical stuff with "bananas"
          And I do some magical stuff with "salad"
      """
    When I run `cucumber examples/where_bigger.feature` interactively
    And I type "where"
    And I type "exit"
    Then it should pass with:
      """
      5:        And I do some magical stuff with "raspberries"
      """
    And the output should contain "6: ->     Then I will write new steps"
    Then it should pass with:
      """
      7:        And I do some magical stuff with "bananas"
      """