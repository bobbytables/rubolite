module Rubolite
  class Client
    attr_reader :admin

    def initialize(admin)
      @admin = admin
    end

    def repos
      @repos ||= admin.parser.repos
    end

    def groups
      @groups ||= admin.parser.groups
    end

    def add_group(name, users)
      groups[name] = users
    end

    def add_repo(repo)
      repos << repo
    end

    def save!
      admin.writer.write!
    end

    def commit!
      admin.git.commit_all("Modified configuration by rubolite")
    end

    def push!
      admin.git.push(admin.repo_origin)
    end
  end
end