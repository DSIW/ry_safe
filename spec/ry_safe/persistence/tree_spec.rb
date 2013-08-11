require "spec_helper"

describe Persistence::Tree do
  subject { Persistence::Tree.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/tree.yml" }

  describe "#prepare" do
    it "should prepare base and touch file" do
      FileUtils.should_receive(:mkdir_p).with(Persistence::Base.new.location)
      FileUtils.should_receive(:touch).with(subject.location)
      subject.should_receive(:load)
      subject.prepare
    end
  end

  describe "#save" do
    it "should write serialized root node to file" do
      Safe::Tree.root.should_receive(:serialize).and_return("serialized root node")
      subject.should_receive(:write).with("serialized root node")

      subject.save
    end
  end

  describe "#load" do
    let(:root_dir) { Safe::RootDir.new }
    it "should read from file and deserialize root node" do
      subject.should_receive(:read).and_return("serialized root node")
      Safe::RootDir.any_instance.should_receive(:deserialize).with("serialized root node").and_return(root_dir)
      Safe::Tree.root.should_receive(:from_other).with(root_dir)

      subject.load
    end
  end

  after do
    fake_home.restore
  end
end
