After('@cucumberize') do |s|
  if s.failed?
    puts "Sorry, no cucumberator when scenario is already failing!"
    return
  end

  last_input = nil

  while true
    print "> "
    input = STDIN.gets.chomp

    begin
      case input
      when "exit"
        break

      when "exit-all"
        Cucumber.wants_to_quit = true
        break
      
      when "help"
        puts %{
          Write a step directly here and watch it happen on the browser
          Available commands:
            save      - saves last step into current feature file
            last-step - display last executed step
            exit      - exits current step
            exit-all  - exists whole Cucumber feature
            help      - display this notification
        }

      when "last-step"
        puts last_input

      when "save"
        if last_input.blank?
          puts "Hm... nothing to save yet?"
        else
          feature_file = File.join(Rails.root, s.file_colon_line.split(":").first)
          spaces = File.readlines(feature_file)[-1] =~ /\S/
          File.open(feature_file, 'a') do |f|
            f.puts((" " * spaces) + last_input) 
            last_input = nil
          end

          puts "Saved to #{feature_file}"
        end

      else
        last_input = input
        input = "#{input.split.first} '#{input.split[1..-1].join(' ')}'"
        puts input
        instance_eval input
      end
    rescue Exception => e
      puts e.inspect
    end
  end
end
