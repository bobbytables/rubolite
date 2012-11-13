module Rubolite
  class Writer
    attr_accessor :write_path
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def write!
      File.open(write_path, "w") do |handler|
        handler.write groups
        handler.write repos
      end
    end

    def groups
      parser.groups.each_with_object([]) do |(name, users), lines|
        lines << "@#{name} = #{users.join(" ")}"
      end.join("\n") + "\n\n"
    end

    def repos
      parser.repos.each_with_object([]) do |repo, blocks|
        blocks << repo_block(repo)
      end.join("\n\n") + "\n"
    end

    def repo_block(repo)
      lines = []
      lines << "repo #{repo.name}"
      repo.users.each do |user|
        lines << "    #{user.permissions} = #{user.name}"
      end

      lines.join("\n")
    end
  end
end