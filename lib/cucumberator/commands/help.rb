module Cucumberator::Commands
  class Help
    class << self
      # return value - wants to quit?
      def perform(*args, &block)
        puts ":: Write a step here and watch it happen on the browser."
        puts ":: Steps are automatically saved unless it raises exception. Use 'save' to force-save it anyway."
        puts ":: Available commands:"
        puts "::   save      - force-saves last step into current feature file"
        puts "::   last-step - display last executed step (to be saved on 'save' command)"
        puts "::   undo      - remove last saved line from feature file"
        puts "::   next      - execute next step and stop"
        puts "::   steps     - display available steps"
        puts "::   where     - display current location in file"
        puts "::   exit      - exits current scenario"
        puts "::   exit-all  - exists whole Cucumber feature"
        puts "::   help      - display this notification"

        false
      end
    end
  end
end
