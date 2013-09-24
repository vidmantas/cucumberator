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
      raise "Sorry, cucumberator is not available when scenario is already failing!" if scenario.failed?
    end

    def set_autocomplete
      commands = %w(exit exit-all help last-step save undo next where whereami steps)

      @steps = all_defined_steps
      @steps.each do |s|
        # remove typical start/end regexp parts
        step = s.gsub(/^\/\^|\$\/$/,'')
        # every step is equal, no matter if When/Then/And, so combining everything for autocomplete
        commands << "When #{step}" << "Then #{step}" << "And #{step}"
      end

      Readline.basic_word_break_characters = ""; # no break chars = no autobreaking for completion input
      Readline.completion_proc = proc { |s| commands.grep( /^#{Regexp.escape(s)}/ ) }
    end

    def current_visitor
      @current_visitor ||= scenario.instance_variable_get("@current_visitor")
    end

    def all_defined_steps
      support_code = current_visitor.runtime.instance_variable_get("@support_code")
      support_code.step_definitions.map { |sd| sd.regexp_source }
    end

    def read_input
      input = Readline.readline("> ", true)
      parse_input(input)
      read_input unless exit_flag
    end

    def mark_exit(totally = false)
      Cucumber.wants_to_quit = true if totally
      self.exit_flag = true
    end

    def parse_input(input)
      case input
      when "exit"
        mark_exit and return

      when "exit-all"
        mark_exit(true)

      when "help"
        display_help

      when "last-step"
        puts last_input

      when "save"
        save_last_input

      when "undo"
        undo

      when "next"
        execute_next_step

      when "steps"
        display_steps

      when "where", "whereami"
        display_current_location

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
      puts "::   next      - execute next step and stop"
      puts "::   steps     - display available steps"
      puts "::   where     - display current location in file"
      puts "::   exit      - exits current scenario"
      puts "::   exit-all  - exists whole Cucumber feature"
      puts "::   help      - display this notification"
    end

    def save_last_input
      if last_input.to_s.empty?
        puts "Hm... nothing to save yet?"
      else
        string_to_save = (" " * spaces_in_last_input) + last_input
        save_to_feature_file(string_to_save)

        puts "Saved `#{last_input}` to #{File.basename(feature_file)}"
        self.last_input = nil
      end
    end

    def save_to_feature_file(string)
      if step_line
        lines = feature_file_lines
        lines.insert(step_line - 1, string.to_s+$/) # $/ - default newline separator
        File.open(feature_file, 'w') { |f| f.puts(lines.join) }
        self.saved_stack << [step_line, string]
        self.step_line += 1
      else
        File.open(feature_file, 'a') { |f| f.puts(string) }
        self.saved_stack << [feature_file_lines.size, string]
      end
    end

    def save_empty_line
      save_to_feature_file("")
      self.last_input = nil
    end

    def execute_cucumber_step(input)
      return if input.to_s.empty?

      self.last_input = input
      world.steps(input)
    end

    def undo
      if saved_stack.empty?
        puts "There's nothing to revert yet"
        return
      end

      lines = feature_file_lines

      remove_line, remove_string = self.saved_stack.pop
      lines.delete_at(remove_line - 1)
      File.open(feature_file, 'w') { |f| f.puts(lines.join) }
      self.step_line -= 1

      puts "Removed `#{remove_string.to_s.strip}` from #{File.basename(feature_file)}"
    end

    def display_current_location
      display_line(step_line - 1)
      display_line(step_line, current: true)
      display_line(step_line + 1)
    end

    def display_line(line_number, opts = {})
      lines = feature_file_lines
      line_string = sprintf("%3d", line_number)

      if opts[:current]
        line_string << ": -> "
      else
        line_string << ":    "
      end

      line_string << lines[line_number-1].to_s
      puts line_string
    end

    def execute_next_step
      next_step = detect_next_step

      if next_step
        puts next_step.backtrace_line
        current_visitor.visit_step(next_step)
        self.step_line = next_step.file_colon_line.split(':').last.to_i
      else
        puts ":: Looks like it's the end of feature file. Happy coding! <3"
        mark_exit(true)
      end
    end

    def detect_next_step
      next_step = nil

      scenario.steps.each do |step|
        if step.status == :skipped and not step.backtrace_line["Then I will write new steps"]
          next_step = step
          break
        end
      end

      next_step
    end

    def feature_file_lines
      File.readlines(feature_file)
    end

    def display_steps
      if @steps and @steps.size > 0
        puts ":: Yay, you have #{@steps.size} steps in your pocket:"
        @steps.each { |s| puts s }
      else
        puts ":: Sorry, no steps detected?"
      end
    end

    ## HELPERS

    def feature_file
      @feature_file ||= File.join(Dir.pwd, scenario.file_colon_line.split(":").first)
    end

    def spaces_in_last_input
      lines = File.readlines(feature_file)
      line = nil

      if step_line
        line  = lines[step_line-1]
        lines = lines.slice(0, step_line-1) if line.to_s.empty?
      end

      if line.to_s.empty?
        line = lines.reverse.detect { |l| !l.to_s.empty? }
      end

      spaces = line.to_s =~ /\S/
      spaces.to_i
    end
  end

end
