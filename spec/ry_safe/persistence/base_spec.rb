# encoding: utf-8

require "spec_helper"

describe Persistence::Base do
  subject { Persistence::Base.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe" }

  describe "#prepare" do
    context "location does not exist" do
      it "should create location" do
        FileUtils.should_receive(:mkdir_p).with(subject.location)
        subject.prepare
      end
    end

    context "location does exist" do
      before { FileUtils.mkdir_p subject.location }

      it "should not create location" do
        FileUtils.should_not_receive(:mkdir_p).with(subject.location)
        subject.prepare
      end
    end
  end

  describe "::register" do
    subject { Persistence::Base }

    its(:register) { should have(3).items }
    its(:register) { should include Persistence::History }
    its(:register) { should include Persistence::Tree }
    its(:register) { should include Persistence::Config }
  end

  describe "#prepare_all" do
    it "should prepare each registered sub class of base" do
      Persistence::History.any_instance.should_receive(:prepare)
      Persistence::Tree.any_instance.should_receive(:prepare)
      Persistence::Config.any_instance.should_receive(:prepare)
      subject.prepare_all
    end
  end

  after do
    fake_home.restore
  end
end
