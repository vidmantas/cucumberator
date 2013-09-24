module Cucumberator::Commands
  class ExitAll
    class << self
      # return value - wants to quit?
      def perform(*args, &block)
        Cucumber.wants_to_quit = true
        true
      end
    end
  end
end
