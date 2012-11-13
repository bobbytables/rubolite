require "spec_helper"
require "tempfile"

describe Rubolite::Writer do
  subject { Rubolite::Writer.new(writer_parser) }
  let(:temp_file) { Tempfile.new("writespec") }

  let(:writer_parser) { Rubolite::Parser.new("./spec/fixtures/gitolite-conf.conf") }
  let(:parser) { Rubolite::Parser.new(temp_file.path) }

  before(:each) { subject.write_path = temp_file.path }

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
    end
  end
end