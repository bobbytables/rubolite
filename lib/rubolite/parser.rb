module Rubolite
  class Parser
    attr_reader :conf_file, :repos

    def initialize(conf_file)
      @conf_file = conf_file
      parse!
    end

    def parse!
      current_repo = nil

      conf_contents.each do |line|
        keyword = line.strip
        case keyword
        when /^repo\s/
          repo_name = parse_repo_line(line)
          repo = Repo.new(repo_name)

          (@repos ||= []) << repo
        end
      end
    end

    def parse_repo_line(repo_line)
      if matched = repo_line.match(/repo ([\w\-\d]+)/)
        matched[1]
      else
        nil
      end
    end

    private

    def conf_contents
      @conf_contents ||= File.readlines(conf_file)
    end
  end
end