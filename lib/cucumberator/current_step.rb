require 'cucumberator/step_line'

module Cucumberator
  class CurrentStep
    attr_accessor :line, :offset
    attr_reader :environment

    def initialize(environment)
      @environment = environment
      @offset = 0
      set_line
    end

    def scenario_sexp
      @scenario_sexp ||= environment.to_sexp.select { |identificator, _| identificator == :step_invocation }
    end

    def increase
      self.offset += 1
      set_line
    end

    def current_sexp
      scenario_sexp[offset]
    end

    def set_line
      self.line = Cucumberator::StepLine.new(current_sexp[1]) if current_sexp
    end
  end
end
