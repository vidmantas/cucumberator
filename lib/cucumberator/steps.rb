module Cucumberator
  class Steps
    def initialize(scenario)
      @scenario = scenario
    end

    def all
      @steps ||= all_defined_steps
    end

    def all_defined_steps
      support_code = current_visitor.runtime.instance_variable_get("@support_code")
      support_code.step_definitions.map { |sd| sd.regexp_source }
    end

    def current_visitor
      @current_visitor ||= @scenario.instance_variable_get("@current_visitor")
    end
  end
end
