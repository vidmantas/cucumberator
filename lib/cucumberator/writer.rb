module Cucumberator
  class Writer
    attr_accessor :world, :scenario, :step_line, :original_step_line, :last_input, :exit_flag, :saved_stack

    FULL_BACKTRACE = false

    def initialize(world, scenario, step_line = nil)
      @world, @scenario = world, scenario
      @step_line = @original_step_line = step_line if step_line
      @saved_stack = []

      check_scenario
      set_autocomplete
      read_input
    end

    def check_scenario
      raise "Sorry, no cucumberator when scenario is already failing!" if scenario.failed?
    end

    def set_autocomplete
      commands = %w(exit exit-all help last-step save undo)
      Readline.completion_proc = proc{|s| commands.grep( /^#{Regexp.escape(s)}/ ) }
    end

    def read_input
      input = Readline.readline("> ", true)
      parse_input(input)
      read_input unless exit_flag
    end

    def parse_input(input)
      case input
      when "exit"
        self.exit_flag = true and return

      when "exit-all"
        Cucumber.wants_to_quit = true
        self.exit_flag = true and return
      
      when "help"
        display_help

      when "last-step"
        puts last_input

      when "save"
        save_last_input

      when "undo" 
        undo

      when ""
        save_empty_line

      else
        begin
          execute_cucumber_step(input)
          save_last_input
        rescue Exception => e
          raise e
        end

      end
    rescue Exception => e
      puts e.inspect
      puts e.backtrace.join("\n") if FULL_BACKTRACE
    end


    ## COMMANDS 

    def display_help
      puts ":: Write a step here and watch it happen on the browser."
      puts ":: Steps are automatically saved unless it raises exception. Use 'save' to force-save it anyway."
      puts ":: Available commands:"
      puts "::   save      - force-saves last step into current feature file"
      puts "::   last-step - display last executed step (to be saved on 'save' command)"
      puts "::   undo      - remove last saved line from feature file"
      puts "::   exit      - exits current scenario"
      puts "::   exit-all  - exists whole Cucumber feature"
      puts "::   help      - display this notification"
    end

    def save_last_input
      if last_input.blank?
        puts "Hm... nothing to save yet?"
      else
        string_to_save = (" " * spaces_in_last_input) + last_input
        save_to_feature_file(string_to_save)

        puts "Saved \"#{last_input}\" to #{File.basename(feature_file)}"
        self.last_input = nil
      end
    end

    def save_to_feature_file(string)
      if step_line
        feature_file_lines = File.readlines(feature_file)
        feature_file_lines.insert(step_line, string.to_s+$/) # $/ - default newline separator
        File.open(feature_file, 'w'){|f| f.puts(feature_file_lines.join) }
        self.step_line += 1
      else
        File.open(feature_file, 'a'){|f| f.puts(string) }
      end

      self.saved_stack << string
    end

    def save_empty_line
      save_to_feature_file("")
      self.last_input = nil
    end

    def execute_cucumber_step(input)
      return if input.blank?

      self.last_input = input
      world.steps(input)
    end

    def undo
      if saved_stack.empty?
        puts "There's nothing to revert yet" and return
      end

      feature_file_lines = File.readlines(feature_file)

      removed = if step_line
        self.step_line -= 1
        feature_file_lines.delete_at(step_line)
      else
        feature_file_lines.pop
      end

      puts "Removed \"#{removed.to_s.strip}\" from #{File.basename(feature_file)}" 

      File.open(feature_file, 'w'){|f| f.puts(feature_file_lines.join) }
      self.saved_stack.pop
    end


    ## HELPERS

    def feature_file
      @feature_file ||= File.join(Rails.root, scenario.file_colon_line.split(":").first)
    end

    def spaces_in_last_input
      spaces = 0
      lines  = File.readlines(feature_file)

      if step_line
        line = lines[step_line-1]
      else
        for l in lines.reverse
          unless l.blank?
            line = l
            break
          end
        end
      end

      spaces = line =~ /\S/
      spaces
    end
  end

end