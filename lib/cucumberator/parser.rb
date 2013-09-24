require 'cucumberator/commands'
require 'cucumberator/feature_file'

module Cucumberator
  class Parser
    FULL_BACKTRACE = false # for debugging

    class << self
      attr_accessor :last_input

      def parse_input(input, scenario, step_line, world, saved_stack)
        if Cucumberator::Commands::AVAILABLE.include?(input)
          runner = command_runner_for(input)
          runner.perform(scenario, step_line, last_input, saved_stack)
        elsif input == ""
          Cucumberator::Commands::Save.save_empty_line(scenario, step_line, saved_stack)
        else
          begin
            execute_cucumber_step(input, world)
            Cucumberator::Commands::Save.perform(scenario, step_line, last_input, saved_stack)
          rescue => e
            puts e.inspect
            puts e.backtrace.join("\n") if FULL_BACKTRACE
          end

          false
        end
      end

      def command_runner_for(command)
        full_klass_name = "Cucumberator::Commands::#{klass_name_for(command)}"
        Object.const_get(full_klass_name)
      end

      def klass_name_for(command)
        command.scan(/\w+/).map(&:capitalize).join
      end

      def execute_cucumber_step(input, world)
        return if input.to_s.empty?

        self.last_input = input
        world.steps(input)
      end
    end
  end
end
