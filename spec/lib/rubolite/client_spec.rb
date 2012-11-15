require "spec_helper"

describe Rubolite::Client do
  let(:admin) { Rubolite::Admin.new("./spec/support/gitolite-admin") }
  subject { Rubolite::Client.new(admin) }

  it "initializes with an admin object" do
    expect { Rubolite::Client.new(admin) }.not_to raise_error
  end

  context "repos" do
    it "represents repos from the parser" do
      expect(subject.repos.map(&:name)).to include "gitolite-admin"
    end

    specify "#add_repo adds a repo" do
      subject.add_repo Rubolite::Repo.new("awesome-repo")
      subject.should have(3).repos
    end
  end

  context "groups" do
    specify "#add_group adds a group" do
      subject.add_group "staff", ["robert", "bobby"]
      subject.should have(1).groups
    end

    specify "#add_group adds a group with users" do
      subject.add_group "staff", ["robert", "bobby"]
      expect(subject.groups["staff"]).to eq %w(robert bobby)
    end
  end

  context "saving" do
    it "saves changes" do
      admin.writer.should_receive(:write!)
      subject.save!
    end

    it "commits the changes to the repo" do
      admin.git.should_receive(:commit_all)
      subject.commit!
    end

    it "pushes changes" do
      origin = admin.repo_origin
      admin.git.should_receive(:push).with(origin)
      subject.push!
    end

    it "saves, commits, and pushes" do
      admin.writer.should_receive(:write!)
      admin.git.should_receive(:commit_all)
      admin.git.should_receive(:push)
      subject.save_and_push!
    end
  end
end