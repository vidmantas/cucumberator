module Cucumberator
  class FeatureFile
    def initialize(scenario)
      @scenario = scenario
    end

    def lines
      File.readlines(file)
    end

    def file
      @feature_file ||= Pathname.new(@scenario.file_colon_line.split(":").first).realpath
    end

    def to_s
      File.basename(file)
    end

    def overwrite(contents)
      File.open(file, 'w') { |f| f.puts(contents) }
    end

    def append(contents)
      File.open(file, 'a') { |f| f.puts(contents) }
    end
  end
end
