Feature: stop execution on cucumberator step & exit sucessfully
  Scenario: using cucumberator step, but cucumberator not required
    Given a file named "examples/simple_hook_test.feature" with:
      """
      Feature: example
        Scenario: stop and exit
          Then I will write new steps
      """
    When I run `cucumber examples/simple_hook_test.feature`
    Then the output should contain "1 step (1 undefined)"

  Scenario: using cucumberator step with cucumberator required
    Given a file named "examples/simple_hook_test.feature" with:
      """
      Feature: example
        Scenario: stop and exit
          Then I will write new steps
      """
    And a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    When I run `cucumber examples/simple_hook_test.feature` interactively
    And I type "exit"
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """