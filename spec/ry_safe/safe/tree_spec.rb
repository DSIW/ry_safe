# encoding: utf-8

require "spec_helper"

describe Safe::Tree do
  subject { Safe::Tree.instance }

  it "should raise an exception when calling #new" do
    expect { Safe::Tree.new }.to raise_error
  end

  it { should be_a Safe::Dir }
  it { should be_a Safe::Node }

  describe "::root" do
    it "should get root node of tree" do
      Safe::Tree.root.should be_a Safe::Dir
    end

    it "should be only one instance" do
      subject.should be Safe::Tree.root
      subject.object_id.should == Safe::Tree.root.object_id
    end
  end
end
