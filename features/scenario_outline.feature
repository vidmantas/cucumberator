Feature: Scenario outline
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

  Scenario: without cucumberator step
    Given a file named "examples/scenario_outline.feature" with:
      """
      Feature: example
        Scenario Outline: run and exit
          When I do some magical stuff with '<fruit>'

        Examples:
          | fruit   |
          | bananas |

      """

    When I run `cucumber examples/scenario_outline.feature` interactively
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
