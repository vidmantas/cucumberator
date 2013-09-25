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
          try_to_execute(input, scenario, step_line, world, saved_stack)
          false
        end
      end

      def try_to_execute(input, scenario, step_line, world, saved_stack)
        execute_cucumber_step(input, world)
        Cucumberator::Commands::Save.perform(scenario, step_line, last_input, saved_stack)
      rescue => e
        puts e.inspect
        puts e.backtrace.join("\n") if FULL_BACKTRACE
      end

      def command_runner_for(command)
        full_klass_name = "Cucumberator::Commands::#{klass_name_for(command)}"
        constantize(full_klass_name)
      end

      def klass_name_for(command)
        command.scan(/\w+/).map(&:capitalize).join
      end

      def execute_cucumber_step(input, world)
        return if input.to_s.empty?

        self.last_input = input
        world.steps(input)
      end

      # copied from ActiveSupport
      # activesupport/lib/active_support/inflector/methods.rb
      def constantize(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end
    end
  end
end
