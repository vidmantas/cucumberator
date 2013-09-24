require 'cucumberator/step_line'

module Cucumberator
  class CurrentStep
    attr_accessor :line

    def initialize(scenario)
      @scenario_sexp = scenario.steps.to_sexp
      @offset = 0
      set_line
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
