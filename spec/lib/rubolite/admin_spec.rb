require "spec_helper"

describe Rubolite::Admin do
  subject { Rubolite::Admin.new }

  context "location" do
    it "sets a location for a repository" do
      path_location = "./spec/support/gitolite-admin"
      subject.path = path_location
      expect(subject.path).to eq(path_location)
    end

    it "raises an error when the path is bad" do
      expect { subject.path = "./idontexist" }.to raise_error(Rubolite::Admin::InvalidPath)
    end

    it "raises an error when the path given isn't a git repository" do
      expect { subject.path = "./spec/support" }.to raise_error(Rubolite::Admin::InvalidGitRepo)
    end

    it "does not raise an error when the path given is a valid git repository" do
      expect { subject.path = "./spec/support/gitolite-admin" }.not_to raise_error(Rubolite::Admin::InvalidGitRepo)
    end
  end

  context "adding repos" do
    let(:repo) { Rubolite::Repo.new }

    it "adds a repo" do
      subject.add_repo repo
      subject.should have(1).repos
    end

    it "raises when trying to add a repo of a bad class" do
      expect { subject.add_repo "bad" }.to raise_error(Rubolite::Admin::InvalidRepo)
    end
  end

  context "config parsing" do
    it "#parser returns a parser object" do
      subject.path = "./spec/support/gitolite-admin"
      expect(subject.parser).to be_kind_of Rubolite::Parser
    end  
  end
end