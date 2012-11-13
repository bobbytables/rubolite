require "spec_helper"

describe Rubolite::Parser do
  subject { Rubolite::Parser.new("./spec/fixtures/gitolite-conf.conf") }
  
  it "initializes with a conf file" do
    conf_file = "./spec/fixtures/gitolite-conf.conf"
    parser = Rubolite::Parser.new(conf_file)
    expect(parser.conf_file).to eq(conf_file)
  end

  specify "#writer returns a writer object" do
    expect(subject.writer).to be_kind_of Rubolite::Writer
  end

  context "parses" do

    specify "repo lines" do
      expect(subject.parse_repo_line("repo somerepo")).to eq("somerepo")
    end

    context "permissions" do
      specify "read permissions" do
        line = "R = robert"
        expect(subject.parse_permissions_line(line)).to eq(["R", "robert"])
      end

      specify "write permissions" do
        line = "W = robert"
        expect(subject.parse_permissions_line(line)).to eq(["W", "robert"])
      end

      specify "read / write permissions" do
        line = "RW = robert"
        expect(subject.parse_permissions_line(line)).to eq(["RW", "robert"])
      end

      specify "read / write / force-push permissions" do
        line = "RW+ = robert"
        expect(subject.parse_permissions_line(line)).to eq(["RW+", "robert"])
      end

      specify "any push permissions" do
        line = "- = robert"
        expect(subject.parse_permissions_line(line)).to eq(["-", "robert"])
      end

      specify "space agnostic" do
        line = "RW+       =      robert"
        expect(subject.parse_permissions_line(line)).to eq(["RW+", "robert"])
      end
    end

    it "parses repos" do
      repo_names = subject.repos.map(&:name)
      expect(repo_names).to include "gitolite-admin"
      expect(repo_names).to include "gitolite-awesome"
    end

    it "parses users" do
      repo = subject.repos.select {|r| r.name == "gitolite-admin" }.first
      expect(repo).to have(1).users
    end

    it "parses users with permissions" do
      repo = subject.repos.select {|r| r.name == "gitolite-admin" }.first
      user = repo.users.first

      expect(user.permissions).to eq "RW+"
    end

    it "parses multiple users" do
      repo = subject.repos.select {|r| r.name == "gitolite-awesome" }.first
      expect(repo).to have(3).users
    end

    context "groups" do
      let(:group_line) { "@somegroup = robert bobby lauren" }

      it "returns group name and users" do
        expect(subject.parse_group_line(group_line)).to eq ["somegroup", %w(robert bobby lauren)]
      end

      it "parses groups" do
        subject.should have(1).groups
      end
    end
  end
end