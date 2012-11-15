module Rubolite
  class Client
    attr_reader :admin, :ssh_keys

    def initialize(admin)
      @admin = admin
      @ssh_keys = []
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

    def add_ssh_key(ssh_key)
      ssh_keys << ssh_key
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

    def save_and_push!
      save!
      commit!
      push!
    end
  end
end