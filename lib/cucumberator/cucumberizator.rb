class Cucumberizator
  attr_accessor :world, :scenario, :step_line, :last_input, :exit_flag

  FULL_BACKTRACE = false

  # Returns Gherkin::Formatter::Model::Step instance to know where we are exactly (contains line no., keyword, name)
  # Warning: fragile!
  def self.extract_current_step(scenario)
    return nil unless scenario

    scenario.raw_steps.first.feature_element
      .instance_variable_get("@current_visitor")
      .instance_variable_get("@listeners").first
      .instance_variable_get("@current_step")
      .instance_variable_get("@step")
      .gherkin_statement
  end

  def initialize(world, scenario, step = nil)
    @world, @scenario = world, scenario
    @step_line = step.line if step

    check_scenario
    set_autocomplete
    read_input
  end

  def check_scenario
    raise "Sorry, no cucumberator when scenario is already failing!" if scenario.failed?
  end

  def set_autocomplete
    commands = %w(exit exit-all help last-step save line)
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

    when "line"
      save_empty_line

    else
      execute_cucumber_step(input)

    end
  rescue Exception => e
    puts e.inspect
    puts e.backtrace.join("\n") if FULL_BACKTRACE
  end


  ## COMMANDS 

  def display_help
    puts ":: Write a step here and watch it happen on the browser"
    puts ":: Available commands:"
    puts "::   save      - saves last step into current feature file"
    puts "::   last-step - display last executed step (to be saved on 'save' command)"
    puts "::   line      - saves empty line into feature file"
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
  end

  def save_empty_line
    File.open(feature_file, 'a'){|f| f.puts }
    puts "New line to #{File.basename(feature_file)}"
    self.last_input = nil
  end

  def execute_cucumber_step(input)
    return if input.blank?

    self.last_input = input
    world.steps(input)
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
