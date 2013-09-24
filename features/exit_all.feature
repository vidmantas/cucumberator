Feature: exit-all command
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    Given a file named "examples/exit_all.feature" with:
      """
      Feature: example
        Scenario: exit-all
          Then I will write new steps
          Then I will write new steps
          Then I will write new steps

        Scenario: should be ignored totally
          Then I will write new steps
          Then I will write new steps
          Then I will write new steps

      """

  Scenario: check `exit-all` command
    When I run `cucumber examples/exit_all.feature` interactively
    And I type "exit-all"
    Then it should fail with:
      """
      1 scenario (1 skipped)
      """
