# encoding: utf-8

require "spec_helper"

describe Command::Base do
  subject { Command::Base.new("touch file") }

  its(:command) { should == "touch" }
  its(:arguments) { should == ["file"] }
  its(:humand_readable_command) { should == "Touch" }

  it "should call method action if " do
    subject.should_receive(:action)
    subject.call
  end
end

describe Command::Touch do
  subject { Command::Touch.new("file") }

  its(:command) { should == "touch" }
  its(:arguments) { should == ["file"] }

  it "should create a new entry" do
    tree = Safe::Tree.root
    subject.call
    tree.should have(1).node
    tree.children.first.name.should == "file"
  end
end
