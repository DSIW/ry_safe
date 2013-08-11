require "spec_helper"

describe Persistence::History do
  subject { Persistence::History.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/history.yml" }

  describe "#prepare" do
    it "should prepare base and touch file" do
      FileUtils.should_receive(:mkdir_p).with(Persistence::Base.new.location)
      FileUtils.should_receive(:touch).with(subject.location)
      subject.should_receive(:load)
      subject.prepare
    end
  end

  after do
    fake_home.restore
  end
end
