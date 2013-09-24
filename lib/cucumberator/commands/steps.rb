module Cucumberator::Commands
  class Steps
    class << self
      def perform(scenario, *args, &block)
        steps = all_steps(scenario)
        if steps and steps.size > 0
          puts ":: Yay, you have #{@steps.size} steps in your pocket:"
          steps.each { |s| puts s }
        else
          puts ":: Sorry, no steps detected"
        end
      end

      def all_steps(scenario)
        @steps ||= Cucumberator::Steps.new(scenario).all
      end
    end
  end
end
