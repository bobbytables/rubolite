require "spec_helper"

describe Rubolite::Parser do
  it "initializes with a conf file" do
    conf_file = "./spec/fixtures/gitolite-conf.conf"
    parser = Rubolite::Parser.new(conf_file)
    expect(parser.conf_file).to eq(conf_file)
  end

  context "parses" do
    subject { Rubolite::Parser.new("./spec/fixtures/gitolite-conf.conf") }

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
  end
end