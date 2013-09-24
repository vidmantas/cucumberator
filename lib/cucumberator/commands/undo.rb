module Cucumberator::Commands
  class Undo
    class << self
      def perform(scenario, step_line, last_input, saved_stack, *args, &block)
        if saved_stack.empty?
          puts "There's nothing to revert yet"
          return false
        end

        new(scenario, step_line, saved_stack)
        false
      end
    end

    def initialize(scenario, step_line, saved_stack)
      @feature_file = Cucumberator::FeatureFile.new(scenario)
      lines = @feature_file.lines

      remove_line, remove_string = saved_stack.pop
      lines.delete_at(remove_line - 1)
      @feature_file.overwrite(lines.join)
      step_line.decrement!

      puts "Removed `#{remove_string.to_s.strip}` from #{@feature_file}"
    end
  end
end
