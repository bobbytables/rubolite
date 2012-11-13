require "spec_helper"
require "tempfile"

describe Rubolite::Writer do
  subject { Rubolite::Writer.new(writer_parser) }
  let(:temp_file) { Tempfile.new("writespec") }

  let(:writer_parser) { Rubolite::Parser.new("./spec/fixtures/gitolite-conf.conf") }
  let(:parser) { Rubolite::Parser.new(temp_file.path) }

  before(:each) { subject.write_path = temp_file.path }

  it "sets write path to parser config path on initialize" do
    writer = Rubolite::Writer.new(parser)
    expect(writer.write_path).to eq parser.conf_file
  end

  it "accepts a write path" do
    expect(subject).to respond_to :write_path
    expect(subject).to respond_to :write_path=
  end

  context "groups" do
    it "creates groups correctly" do
      expect(subject.groups).to include "@staff = gitolite robert"
    end

    it "writes groups correctly" do
      subject.write!
      expect(parser).to have(1).groups
    end
  end

  context "repos" do
    it "creates repos correctly" do
      expect(subject.repos).to include "repo gitolite-admin"
      expect(subject.repos).to include "repo gitolite-awesome"
    end

    it "writes repos correctly" do
      subject.write!
      expect(parser).to have(2).repos
    end

    context "users" do
      let(:repo) { Rubolite::Repo.new("somerepo") }
      before(:each) do
        repo.add_user Rubolite::User.new "robert", "RW+"
      end

      it "adds users for a repo block correctly" do
        expect(subject.repo_block(repo)).to include "RW+ = robert"
      end

      it "writes users correctly" do
        subject.write!
        repo = parser.repos.select {|r| r.name == "gitolite-admin" }.first
        user = repo.users.select {|u| u.name == "gitolite" }.first

        expect(user.name).to eq("gitolite")
        expect(user.permissions).to eq("RW+")
      end
    end
  end
end