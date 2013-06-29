# encoding: utf-8

require "spec_helper"

describe Command do
  before do
    Safe::Tree.root.clear
  end

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
      tree.children.first.should be_a Safe::Entry
    end
  end

  describe Command::MkDir do
    subject { Command::MkDir.new("dir") }

    its(:command) { should == "mkdir" }
    its(:arguments) { should == ["dir"] }

    it "should create a new entry" do
      tree = Safe::Tree.root
      subject.call
      tree.should have(1).node
      tree.children.first.name.should == "dir"
      tree.children.first.should be_a Safe::Dir
    end
  end

  describe Command::ChangeDirectory do
    subject { Command::ChangeDirectory.new("/root/dir") }

    its(:command) { should == "cd" }
    its(:arguments) { should == ["/root/dir"] }

    it "should change current working dir to specified directory" do
      tree = Safe::Tree.root
      # prepare tree
      tree << Safe::Dir.new("dir")
      tree.should have(1).node
      tree.children.first.name.should == "dir"
      tree.children.first.should be_a Safe::Dir
      subject.call
      current = Safe::Tree.current
      current.name.should == "dir"
      current.parents.should == [tree]
    end
  end
end
