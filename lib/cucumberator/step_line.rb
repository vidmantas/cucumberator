module Cucumberator
  class StepLine
    attr_accessor :number

    def initialize(line)
      @number = line.to_i
    end

    def -(other)
      number - other.to_i
    end

    def +(other)
      number + other.to_i
    end

    def set(other)
      self.number = other.to_i
    end

    def increment!
      self.number += 1
    end

    def decrement!
      self.number -= 1
    end
  end
end
