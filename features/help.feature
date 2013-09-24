Feature: help command
  Background:
    Given a file named "examples/support/env.rb" with:
      """
      require 'cucumberator'
      """
    Given a file named "examples/help.feature" with:
      """
      Feature: example
        Scenario: help
          Then I will write new steps

      """

  Scenario: check help command
    When I run `cucumber examples/help.feature` interactively
    And I type "help"
    And I type "exit"
    Then it should pass with:
      """
      :: Write a step here and watch it happen on the browser.
      :: Steps are automatically saved unless it raises exception. Use 'save' to force-save it anyway.
      :: Available commands:
      ::   save      - force-saves last step into current feature file
      ::   last-step - display last executed step (to be saved on 'save' command)
      ::   undo      - remove last saved line from feature file
      ::   next      - execute next step and stop
      ::   steps     - display available steps
      ::   where     - display current location in file
      ::   exit      - exits current scenario
      ::   exit-all  - exists whole Cucumber feature
      ::   help      - display this notification
      """
