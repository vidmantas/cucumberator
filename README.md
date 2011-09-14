Cucumberator is Cucumber extension to write steps in command line while whatching how browser responds to them:

## Usage

* Put @cucumberize tag in front of Scenario you want to append with new steps
* Fire up the cucumber and wait until prompt shows up
* Write a step and when happy, type 'save' to get it saved into your .feature file

## Installation

If you use bundler (and you should), add 'cucumberator' to your Gemfile. Otherwise, install with
	
	gem install cucumberator

Then require it in one of your ruby files under features/support (e.g. env.rb)
	
	require 'cucumberator'

Now put @cucumberize before any Scenario you want to fill up, for example

	@javascript @cucumberize
  	Scenario: check fancy ajax login
    	Given user with email some@example.com

and then run this feature file and watch your console for prompt shows up.

## What cucumberator DOES NOT DO

It doesn't let you define your new step defitions yet.