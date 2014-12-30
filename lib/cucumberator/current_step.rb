require 'cucumberator/step_line'

module Cucumberator
  class CurrentStep
    attr_accessor :line

    def initialize(environment)
      @environment = environment
      check_for_scenario_outline!

      @scenario_sexp = steps.to_sexp
      @offset = 0
      set_line
    end

    def check_for_scenario_outline!
      return unless @environment.respond_to?(:scenario_outline)

      @environment = @environment.scenario_outline
    end

    def steps
      @environment.instance_variable_get(:@steps)
    end

    def increase
      @offset += 1
      set_line
    end

    def set_line
      current_sexp = @scenario_sexp[@offset]
      self.line = Cucumberator::StepLine.new(current_sexp[1]) if current_sexp
    end
  end
end
