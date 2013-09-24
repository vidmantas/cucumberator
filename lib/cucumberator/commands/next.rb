module Cucumberator::Commands
  class Next
    class << self
      def perform(scenario, step_line, *args, &block)
        new(scenario, step_line).next_step
      end
    end

    def initialize(scenario, step_line)
      @scenario, @step_line = scenario, step_line
      @steps = Cucumberator::Steps.new(@scenario)
    end

    def next_step
      if next_step = detect_next_step
        puts next_step.backtrace_line
        @steps.current_visitor.visit_step(next_step)
        @step_line.set(next_step.file_colon_line.split(':').last.to_i)
        false
      else
        puts ":: Looks like it's the end of feature file. Happy coding! <3"
        true
      end
    end

    def detect_next_step
      next_step = nil

      @scenario.steps.each do |step|
        if step.status == :skipped and not step.backtrace_line["Then I will write new steps"]
          next_step = step
          break
        end
      end

      next_step
    end
  end
end
