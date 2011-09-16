require "readline"
require "cucumberator/cucumberizator"

After('@cucumberize') do |scenario|
  Cucumberizator.new(self, scenario)
end