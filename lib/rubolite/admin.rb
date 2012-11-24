module Rubolite
  class Admin
    InvalidPath = Class.new(Exception)
    InvalidGitRepo = Class.new(Exception)
    InvalidRepo = Class.new(Exception)

    attr_reader :path, :repos

    def initialize(path=nil)
      @path = path if path && valid_path?(path)
    end

    def reset!
      @parser = nil
      @writer = nil
      @git = nil
      @repo_origin = nil
      @client = nil

      self
    end

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
      @writer ||= parser.writer
    end

    def git
      @git ||= Git.open(path)
    end

    def repo_origin
      @repo_origin ||= git.remote("origin")
    end

    def client
      @client ||= Client.new(self)
    end

    private

    def valid_path?(path)
      raise InvalidPath, "#{path} is not a directory" unless File.directory?(path)
      raise InvalidGitRepo, "#{path} is not a git repository" unless File.directory?("#{path}/.git")
      true
    end
  end
end