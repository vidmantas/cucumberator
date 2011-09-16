class Cucumberizator
  attr_accessor :world, :scenario, :last_input, :exit_flag

  FULL_BACKTRACE = false

  def initialize(world, scenario)
    @world, @scenario = world, scenario
    
    check_scenario
    set_autocomplete
    read_input
  end

  def check_scenario
    raise "Sorry, no cucumberator when scenario is already failing!" if scenario.failed?
  end

  def set_autocomplete
    commands = %w(exit exit-all help last-step save)
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
    puts "::   exit      - exits current scenario"
    puts "::   exit-all  - exists whole Cucumber feature"
    puts "::   help      - display this notification"
  end

  def save_last_input
    if last_input.blank?
      puts "Hm... nothing to save yet?"
    else
      File.open(feature_file, 'a') do |f|
        f.puts((" " * spaces_in_last_line) + last_input) 
      end

      puts "Saved \"#{last_input}\" to #{File.basename(feature_file)}"
      self.last_input = nil
    end
  end

  def execute_cucumber_step(input)
    self.last_input = input
    input = "#{input.split.first} '#{input.split[1..-1].join(' ')}'" # making it like >>  When 'I do this and that'
    world.instance_eval input
  end


  ## HELPERS

  def feature_file
    @feature_file ||= File.join(Rails.root, scenario.file_colon_line.split(":").first)
  end

  def spaces_in_last_line
    for line in File.readlines(feature_file).reverse
      unless line.blank?
        spaces = line =~ /\S/
        return spaces
      end
    end

    0
  end
end
