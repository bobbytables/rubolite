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

  context "ssh keys" do
    specify "#add_ssh_key adds an ssh key" do
      subject.add_ssh_key "robert", Rubolite::SSHKey.new("ssh-rsa", "whatupfinger", "robert@local")
      subject.should have(1).ssh_keys
    end
  end

  context "saving" do
    let(:git) { stub status: status, add: nil }
    let(:status) { stub changed: changed }
    let(:changed) { Hash.new }

    it "saves changes" do
      admin.writer.should_receive(:write!)
      subject.save!
    end

    it "saves ssh keys" do
      ssh_key = Rubolite::SSHKey.new("ssh-rsa", "whatupfinger", "robert@local")
      key_path = "#{admin.path}/keydir"

      ssh_key.should_receive(:write_for).with("robert", key_path)

      subject.add_ssh_key("robert", ssh_key)
      subject.save_ssh_keys!
    end

    it "commits the changes to the repo" do
      admin.git.should_receive(:commit)
      subject.commit!
    end

    it "commits only if things have changed" do
      subject.admin.stub(git: git)

      admin.git.should_not_receive(:commit_all)
      subject.commit!
    end

    it "pushes changes" do
      origin = admin.repo_origin
      admin.git.should_receive(:push).with(origin)
      subject.push!
    end

    it "saves, commits, and pushes" do
      subject.should_receive(:save!)
      subject.should_receive(:save_ssh_keys!)
      subject.should_receive(:commit!)
      subject.should_receive(:push!)
      subject.save_and_push!
    end

    it "resets and reparses after save is called" do
      subject.should_receive(:reset!)
      subject.save!
    end

    it "resets and reparses after save_ssh_keys is called" do
      subject.should_receive(:reset!)
      subject.save_ssh_keys!
    end
  end

  context "resetting" do
    it "resets the admin" do
      subject.admin.should_receive(:reset!)
      subject.reset!
    end

    it "resets it's repos" do
      repos = subject.repos
      subject.reset!
      expect(subject.repos).not_to eq(repos)
    end

    it "resets it's groups" do
      groups = subject.groups.object_id
      subject.reset!
      expect(subject.groups.object_id).not_to eq(groups)
    end

    it "resets it's ssh keys" do
      ssh_keys = subject.ssh_keys.object_id
      subject.reset!
      expect(subject.ssh_keys.object_id).not_to eq(ssh_keys)
    end
  end

  context "status reporting" do
    let(:git) { stub status: status }
    let(:status) { stub changed: changed }
    let(:changed) { Hash.new }

    before(:each) do
      subject.admin.stub(git: git)
    end

    it "reports that it is commitable" do
      changed.should_receive(:size).and_return(1)
      expect(subject).to be_commitable
    end
  end
end