require "readline"
require "cucumberator/current_step"
require "cucumberator/writer"
# require 'pry'

After('@cucumberize') do |scenario|
  Cucumberator::Writer.new(self, scenario)
end

Before do |scenario|
  @current_cucumberator_scenario = scenario
  @current_step = Cucumberator::CurrentStep.new(scenario)
end

AfterStep do
  @current_step.increase
end

Then /^I will write new steps$/ do
  Cucumberator::Writer.new(self, @current_cucumberator_scenario, @current_step.line)
end
