Feature: next
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
    Given a file named "examples/next.feature" with:
      """
      Feature: example
        Scenario: stop where exit
          Then I will write new steps
          When I do some magical stuff with 'apples'
          When I do some magical stuff with 'oranges'
          When I do some magical stuff with 'bananas'
          When I do some magical stuff with 'water'

      """

  Scenario: one next
    When I run `cucumber examples/next.feature` interactively
    And I type "next"
    And I type "where"
    And I type "exit"
    Then it should pass with:
      """
      examples/next.feature:4:in `When I do some magical stuff with 'apples'
      """
    And it should pass with:
      """
      4: ->     When I do some magical stuff with 'apples'
      """
