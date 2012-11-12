module Rubolite
  class User
    attr_accessor :name, :permissions

    def initialize(name=nil, permissions=nil)
      self.name = name
      self.permissions = permissions
    end
  end
end