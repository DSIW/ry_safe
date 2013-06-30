# encoding: utf-8

require "spec_helper"

describe Command do
  before do
    Safe::Tree.root.clear
  end

  describe Command::Base do
    subject { Command::Base.new("touch", "file") }

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
    let(:tree) { Safe::Tree.root }
    let(:dir) { Safe::Dir.new("dir") }
    let(:current) { Safe::Tree.current }

    before do
      Safe::Tree.reset_current
      tree << dir
    end

    subject { Command::ChangeDirectory.new("/root/dir") }

    its(:command) { should == "cd" }
    its(:arguments) { should == ["/root/dir"] }

    it "should change current working dir to specified directory" do
      subject.call
      current.should be dir
    end
  end

  describe Command::Move do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Command::Move.new("/root/from", "/root/to") }

    its(:command) { should == "mv" }
    its(:arguments) { should == ["/root/from", "/root/to"] }

    its(:source) { should be from }
    its(:destination) { should be to }

    it "should move node to specified directory" do
      subject.call

      tree.children.should == [to]
      to.children.should == [from]
    end
  end

  describe Command::Copy do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Command::Copy.new("/root/from", "/root/to") }

    its(:command) { should == "cp" }
    its(:arguments) { should == ["/root/from", "/root/to"] }

    its(:source) { should be from }
    its(:destination) { should be to }

    it "should copy node to specified directory" do
      subject.call

      tree.children.should == [from, to]
      to.children.should == [from]
    end
  end

  describe Command::Remove do
    let(:tree) { Safe::Tree.root }
    let(:node) { Safe::Node.new("node") }
    let(:dir) { Safe::Dir.new("dir") }

    before do
      tree << node
      tree << dir
    end

    subject { Command::Remove.new("/root/node") }

    its(:command) { should == "rm" }
    its(:arguments) { should == ["/root/node"] }

    its(:node) { should be node }

    it "should remove node" do
      removed_node = subject.call

      tree.children.should == [dir]
      removed_node.should be_frozen
      removed_node.parent.should be_nil
    end
  end

  describe Command::Dispatcher do
    subject { Command::Dispatcher.new("mv /from /to") }

    its(:key) { should == "mv" }
    its(:arguments) { should == ["/from", "/to"] }
    its(:command_class) { should == Command::Move }
    its(:command) { should be_a Command::Move }
    its("command.arguments") { should == ["/from", "/to"] }

    it "should get the right commands" do
      Command::Dispatcher.commands.should == %w(touch mkdir cd cp mv rm)
    end

    context "without arguments" do
      subject { Command::Dispatcher.new("mv") }

      its(:key) { should == "mv" }
      its(:arguments) { should == [] }
    end

    context "command class key does not exist" do
      subject { Command::Dispatcher.new("no") }

      its(:key) { should == "no" }
      it "should raise" do
        expect { subject.command_class }.to raise_error Error::NoCommand
        expect { subject.command }.to raise_error Error::NoCommand
        expect { subject.call }.to raise_error Error::NoCommand
      end
    end
  end
end
