module Cucumberator::Commands
  class Exit
    class << self
      # return value - wants to quit?
      def perform(*args, &block)
        true
      end
    end
  end
end
