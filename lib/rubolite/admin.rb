module Rubolite
  class Admin
    InvalidPath = Class.new(Exception)
    InvalidGitRepo = Class.new(Exception)
    InvalidRepo = Class.new(Exception)

    attr_reader :path, :repos

    def path=(new_path)
      valid_path?(new_path)
      @path = new_path
    end

    def add_repo(repo)
      raise InvalidRepo, "Repo not type of Rubolite::Repo, got #{repo.class}" unless repo.kind_of?(Repo)
      (@repos ||= []) << repo
    end
    alias :<< :add_repo

    def parser
      @parser ||= Parser.new("#{path}/conf/gitolite.conf")
    end

    def writer
      parser.writer
    end

    private

    def valid_path?(path)
      raise InvalidPath, "#{path} is not a directory" unless File.directory?(path)
      raise InvalidGitRepo, "#{path} is not a git repository" unless File.directory?("#{path}/.git")
    end
  end
end