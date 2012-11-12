module Rubolite
  class Admin
    InvalidPath = Class.new(Exception)
    InvalidGitRepo = Class.new(Exception)
    
    attr_reader :path

    def path=(new_path)
      valid_path?(new_path)
      @path = new_path
    end

    private

    def valid_path?(path)
      raise InvalidPath, "#{path} is not a directory" unless File.directory?(path)
      raise InvalidGitRepo, "#{path} is not a git repository" unless File.directory?("#{path}/.git")
    end
  end
end