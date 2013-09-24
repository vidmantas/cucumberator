module Cucumberator::Commands
  class Where
    class << self
      # return value - wants to quit?
      def perform(scenario, step_line, *args, &block)
        new(scenario, step_line)
        false
      end
    end

    def initialize(scenario, step_line)
      @feature_file = Cucumberator::FeatureFile.new(scenario)

      display_line(step_line - 1)
      display_line(step_line.number, current: true)
      display_line(step_line + 1)
    end

    def display_line(line_number, opts = {})
      lines = @feature_file.lines
      line_string = sprintf("%3d", line_number)

      if opts[:current]
        line_string << ": -> "
      else
        line_string << ":    "
      end

      line_string << lines[line_number-1].to_s
      puts line_string
    end
  end
end
