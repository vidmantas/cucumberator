require 'cucumberator/parser'
require 'cucumberator/steps'

module Cucumberator
  class Input
    attr_accessor :world, :scenario, :step_line, :last_input, :exit_flag, :saved_stack

    def initialize(world, scenario, step_line = nil)
      @world, @scenario = world, scenario
      @step_line = step_line if step_line
      @saved_stack = []

      check_scenario
      set_autocomplete
      read_input
    end

    def check_scenario
      raise "Sorry, cucumberator is not available when scenario is already failing!" if scenario.failed?
    end

    def read_input
      input = Readline.readline("> ", true)
      exit_flag = Cucumberator::Parser.parse_input(input, scenario, step_line, world, saved_stack)
      read_input unless exit_flag
    end

    def set_autocomplete
      commands = Cucumberator::Commands::AVAILABLE

      Cucumberator::Steps.new(scenario).all.each do |s|
        # remove typical start/end regexp parts
        step = s.gsub(/^\/\^|\$\/$/,'')
        # every step is equal, no matter if When/Then/And, so combining everything for autocomplete
        commands << "When #{step}" << "Then #{step}" << "And #{step}"
      end

      Readline.basic_word_break_characters = ""; # no break chars = no autobreaking for completion input
      Readline.completion_proc = proc { |s| commands.grep( /^#{Regexp.escape(s)}/ ) }
    end
  end
end
