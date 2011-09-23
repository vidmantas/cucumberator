module Cucumberator
  class CurrentStep
    attr_accessor :line

    def initialize(scenario)
      @scenario_sexp = scenario.instance_variable_get("@steps").to_sexp
    end

    def increase
      if self.line
        @offset += 1
      else
        @offset = 0
      end

      self.line = @scenario_sexp[@offset][1]
    end
  end
end