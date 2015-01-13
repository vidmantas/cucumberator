Cucumberator is Cucumber extension to write steps in command line, whatch how browser responds to them and save directly to your .feature file.

[![Gem Version](https://badge.fury.io/rb/cucumberator.png)](http://badge.fury.io/rb/cucumberator)
[![Dependency Status](https://gemnasium.com/vidmantas/cucumberator.png)](https://gemnasium.com/vidmantas/cucumberator)
[![Code Climate](https://codeclimate.com/github/vidmantas/cucumberator.png)](https://codeclimate.com/github/vidmantas/cucumberator)
[![Build Status](https://travis-ci.org/vidmantas/cucumberator.png)](https://travis-ci.org/vidmantas/cucumberator)

## How to use

* Place a step "Then I will write new steps" anywhere in scenario [PREFERRED]
* Or put @cucumberize tag in front of **last** scenario you want to append with new steps.
* Fire up the cucumber and wait until prompt shows up.
* Write a step, watch it happen on the browser!

All steps are **automatically saved** into .feature file unless it's unsuccessful. If you're unhappy with the last step, type "undo". See all commands with "help".

If you have Continuous Integration, do not forget to remove cucumberator tag/step before pushing! ;-)

## Available commands

When you're in cucumberator prompt, the following commands are available:

* save      - force-saves last step into current feature file
* last-step - display last executed step (to be saved on 'save' command)
* undo      - remove last saved line from feature file
* next      - execute next step and stop
* steps     - display available steps
* where     - display current location in file
* exit      - exits current scenario
* exit-all  - exists whole Cucumber feature
* help      - displays all available commands

## Installation

If you use bundler (and you should), add to your Gemfile

```ruby
gem 'cucumberator', require: false
```

Otherwise, install with

```sh
gem install cucumberator
```

Then require it in one of your ruby files under features/support (e.g. env.rb)

```ruby
require 'cucumberator'
```

Now use special step in any place:

```
# ...some steps...
Then I will write new steps
# ...can be the end or other steps...
```

or put @cucumberize before **last** scenario you want to fill up, for example

```
@cucumberize
Scenario: check fancy ajax login
  Given a user with login of "likeaboss"
```

and then run this feature file, watch your console for prompt to show up. Enjoy writing steps on the go!

## Compatibility

Latest cucumberator version supports:

* Cucumber >= 1.3
* Ruby >= 1.9
* JRuby >= 1.7.4 (1.9 mode)

Check for compatibility details on [Travis](https://travis-ci.org/vidmantas/cucumberator)

## Want to contribute?

Fork the project, run tests with:

```sh
bundle exec cucumber features
```

then code, code, code and provide me a pull request <3
...Or just fill in a [ticket](https://github.com/vidmantas/cucumberator/issues)

## Sponsors

Sponsored (and used) by [SameSystem](http://www.samesystem.com).
