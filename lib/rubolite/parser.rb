module Rubolite
  class Parser
    attr_reader :conf_file, :repos, :groups

    def initialize(conf_file)
      @conf_file = conf_file
      @groups = {}
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

          current_repo = repo
        when /^(R|W|\-)/
          next unless current_repo

          permissions, user = parse_permissions_line(line)
          user = User.new(user, permissions)
          current_repo.add_user(user)
        when /^@\w/
          group_name, users = parse_group_line(line)
          @groups[group_name] ||= [] 
          @groups[group_name] += users
        end
      end

      self
    end

    def parse_repo_line(repo_line)
      if matched = repo_line.match(/repo ([\w\-\d]+)/)
        matched[1]
      else
        nil
      end
    end

    def parse_permissions_line(permission_line)
      if matched = permission_line.match(/([R|W|\+\-]+)\s+=\s+([\w\d\-]+)/)
        [matched[1], matched[2]]
      else
        []
      end
    end

    def parse_group_line(group_line)
      if matched = group_line.match(/@([\w]+)\s+=\s+(.*)/)
        group_name = matched[1]
        names = matched[2].split(" ")
        
        [group_name, names]
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