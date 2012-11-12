require "spec_helper"

describe Rubolite::Repo do
  subject { Rubolite::Repo.new }
  let(:admin) { Rubolite::Admin.new }

  context "names" do
    specify { expect(subject).to respond_to :name= }
    specify { expect(subject).to respond_to :name }
  end
end