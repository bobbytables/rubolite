module Rubolite
  class Repo
    attr_accessor :name
    attr_reader :users

    def initialize(name=nil)
      @name = name
    end

    def add_user(user)
      (@users ||= []) << user
    end
  end
end