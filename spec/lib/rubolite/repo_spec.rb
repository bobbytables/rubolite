require "spec_helper"

describe Rubolite::Repo do
  subject { Rubolite::Repo.new }
  let(:admin) { Rubolite::Admin.new }

  context "names" do
    specify { expect(subject).to respond_to :name= }
    specify { expect(subject).to respond_to :name }

    it "initializes with a name" do
      repo = Rubolite::Repo.new("newname")
      expect(repo.name).to eq("newname")
    end
  end

  context "users" do
    let(:user) { Rubolite::User.new "robert", "RW+" }
    let(:repo) { Rubolite::Repo.new("newname") }

    it "adds a user" do
      repo.add_user(user)
      expect(repo.users).to include user
    end
  end
end