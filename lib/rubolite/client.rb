module Rubolite
  class Client
    attr_reader :admin, :ssh_keys

    def initialize(admin)
      @admin = admin
      @ssh_keys = {}
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

    def add_ssh_key(user, ssh_key)
      ssh_keys[user] = ssh_key
    end

    def save!
      admin.writer.write!
      reset!
    end

    def save_ssh_keys!
      ssh_keys.each do |user, key|
        key.write_for user, "#{admin.path}/keydir"
      end
      reset!
    end

    def commit!
      admin.git.add('.')
      admin.git.commit_all("Modified configuration by rubolite")
    end

    def push!
      admin.git.push(admin.repo_origin)
    end

    def save_and_push!
      save!
      save_ssh_keys!
      commit!
      push!
    end

    def reset!
      admin.reset!
      @repos = nil
      @groups = nil
      @ssh_keys = {}
    end
  end
end