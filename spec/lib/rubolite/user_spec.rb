require "spec_helper"

describe Rubolite::User do
  subject { Rubolite::User.new }
  
  context "names" do
    specify { expect(subject).to respond_to :name= }
    specify { expect(subject).to respond_to :name }
  end
end