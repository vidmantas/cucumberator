Cucumberator is Cucumber extension to write steps in command line, whatch how browser responds to them and save directly to your .feature file.

## How to use

* Put @cucumberize tag in front of Scenario you want to append with new steps
* Fire up the cucumber and wait until prompt shows up
* Write a step and when happy, type 'save' to get it saved into your .feature file

## Installation

If you use bundler (and you should), add to your Gemfile
	
	gem "cucumberator", :require => false
		
Otherwise, install with
	
	gem install cucumberator

Then require it in one of your ruby files under features/support (e.g. env.rb)
	
	require 'cucumberator'

Now put @cucumberize before any Scenario you want to fill up, for example

	@javascript @cucumberize
	Scenario: check fancy ajax login
      Given user with email some@example.com

and then run this feature file and watch your console for prompt shows up - after all existing steps are finished.

## TODO

* support of multiple scenarios per feature file
* autocomplete for available steps

## SUGGESTIONS?

Drop me a line or free feel to contribute!