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

    it "parses repos" do
      repo_names = subject.repos.map(&:name)
      expect(repo_names).to include "gitolite-admin"
    end
  end
end