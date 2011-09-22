require "readline"
require "cucumberator/cucumberizator"

After('@cucumberize') do |scenario|
  Cucumberizator.new(self, scenario)
end

Before do |scenario|
  @current_cucumberator_scenario = scenario
end

AfterStep do
  @current_step = Cucumberizator.extract_current_step(@current_cucumberator_scenario)
end

Then /^I will write new steps$/ do
  Cucumberizator.new(self, @current_cucumberator_scenario, @current_step)
end