require "spec_helper"

describe Persistence::File do
  subject { Persistence::File.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == Persistence::Base.new.location }

  describe "#prepare" do
    it "should prepare base and touch file" do
      FileUtils.should_receive(:mkdir_p).with(Persistence::Base.new.location)
      FileUtils.should_receive(:touch).with(subject.location)
      subject.prepare
    end
  end

  #it "should not overwrite files if they exist" do
  #end

  after do
    fake_home.restore
  end
end
