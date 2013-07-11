require "spec_helper"

describe Persistence::Config do
  subject { Persistence::Config.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/config.yml" }

  describe "#prepare" do
    it "should prepare base and touch file" do
      FileUtils.should_receive(:mkdir_p).with(Persistence::Base.new.location)
      FileUtils.should_receive(:touch).with(subject.location)
      subject.prepare
    end
  end

  after do
    fake_home.restore
  end
end
