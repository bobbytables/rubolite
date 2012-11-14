module Rubolite
  # http://unix.stackexchange.com/questions/23590/ssh-public-key-comment-separator
  # This class represents the structure of SSH public keys as defined in RFC4716

  class SSHKey
    attr_accessor :type, :key, :comment

    def initialize(type, key, comment)
      self.type    = type
      self.key     = key
      self.comment = comment
    end

    def self.from_file(path)
      key_contents = File.read(path)
      new(*key_parts(key_contents))
    end

    def self.from_string(string)
      new(*key_parts(string))
    end

    def self.key_parts(key_contents)
      key_contents.split " "
    end

    def write_for(username, directory)
      File.open("#{directory}/#{username}.pub", "w") do |handle|
        handle.write public_key_contents
        handle.close
      end
    end

    private

    def public_key_contents
      [type, key, comment].join(" ")
    end
  end
end