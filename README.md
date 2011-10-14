Cucumberator is Cucumber extension to write steps in command line, whatch how browser responds to them and save directly to your .feature file.

## How to use

* Put @cucumberize tag in front of empty Scenario you want to append with new steps.
* Or place step "Then I will write new steps" anywhere in scenario.
* Fire up the cucumber and wait until prompt shows up.
* Write a step, watch it happen on the browser! 

All steps are **automatically saved** into .feature file unless it's unsuccessful. If you're unhappy with the last step, type "undo". See all commands with "help".

If you have Continuous Integration, do not forget to remove cucumberator tag/step before pushing! ;-)

## Installation

If you use bundler (and you should), add to your Gemfile
	
	gem "cucumberator", :require => false
		
Otherwise, install with
	
	gem install cucumberator

Then require it in one of your ruby files under features/support (e.g. env.rb)
	
	require 'cucumberator'

Now use special step in any place:

	# ...some steps...
	Then I will write new steps
	# ...can be the end or other steps...

or put @cucumberize before last **empty** Scenario you want to fill up, for example

	@javascript @cucumberize
	Scenario: check fancy ajax login

and then run this feature file, watch your console for prompt to show up. Enjoy writing steps on the go!

## TODO

* tests
* "next" command to execute next step from scenario and stop

## SUGGESTIONS?

Drop me a line or feel free to contribute!