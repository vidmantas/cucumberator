module Cucumberator::Commands
  class LastStep
    class << self
      def perform(_, _, last_input, *args, &block)
        puts "It was: `#{last_input}`"
      end
    end
  end
end
