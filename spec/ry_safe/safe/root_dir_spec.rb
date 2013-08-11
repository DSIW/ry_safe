# encoding: utf-8

require "spec_helper"

describe Safe::RootDir do
  subject { Safe::RootDir.new }

  # Node
  # Dir < DirNode
  # Entry
  let(:node) { Safe::Node.new("Node") }
  before { dir << dir_node }
  let(:dir) { Safe::Dir.new("Dir") }
  let(:dir_node) { Safe::Node.new("DirNode") }
  let(:entry) {
    entry = Safe::Entry.new("title")
    entry.username = "UserName"
    entry.password = "_123456 "
    entry
  }

  before { subject.clear }

  it { should be_a Safe::Dir }
  it { should be_a Safe::Node }

  describe "personal working directory" do
    let(:new_pwd) { Safe::Dir.new("new_current_dir") }
    let(:dir_not_in_tree) { Safe::Dir.new("not_in_tree") }

    before do
      subject.clear
      subject << new_pwd
    end

    it "should set and get working directory" do
      subject.current = new_pwd
      subject.current.should be new_pwd
    end

    it "should get root if no current is specified" do
      subject.current.should be subject
    end

    it "should not set current if dir isn't included in tree" do
      expect { subject.current = dir_not_in_tree }.to raise_error Error::NotInTree
    end

    describe "#clear" do
      before { subject.clear }

      it "should clear children" do
        subject.children.should be_empty
      end

      it "should reset current" do
        subject.current.should be subject
      end
    end

    describe "#reset_current" do
      before { subject.reset_current }

      it "should reset current" do
        subject.current.should be subject
      end
    end

    describe "#go_up" do
      it "should set root (parent of current) as current" do
        subject.current = new_pwd
        subject.go_up
        subject.current.should be subject
      end
    end

    it "should set and get working directory" do
      subject.current = new_pwd
      subject.current.should == new_pwd
    end
  end

  describe "#serialize" do
    before do
      subject << node
      subject << dir
      subject << entry
      subject.current = dir
    end

    it "should serialize the right attributes" do
      subject.serialize.should == <<-EOC
--- !ruby/object:RySafe::Safe::RootDir
name: root
children:
- !ruby/object:RySafe::Safe::Node
  name: Node
- !ruby/object:RySafe::Safe::Dir
  name: Dir
  children:
  - !ruby/object:RySafe::Safe::Node
    name: DirNode
- !ruby/object:RySafe::Safe::Entry
  name: title
  username: UserName
  password: '_123456 '
  website: 
  comment: 
  tags: !ruby/array:RySafe::Safe::Tags []
current: /root/Dir
      EOC
    end
  end

  describe "#deserialize" do
    it "should deserialize the right attributes" do
      new_obj = subject.deserialize <<-EOC
--- !ruby/object:RySafe::Safe::RootDir
name: root
children:
- !ruby/object:RySafe::Safe::Node
  name: Node
- !ruby/object:RySafe::Safe::Dir
  name: Dir
  children:
  - !ruby/object:RySafe::Safe::Node
    name: DirNode
- !ruby/object:RySafe::Safe::Entry
  name: title
  username: UserName
  password: '_123456 '
  website: 
  comment: 
  tags: !ruby/array:RySafe::Safe::Tags []
current: /root/Dir
      EOC

      new_obj.name.should == "root"
      new_obj.current.should be new_obj.children[1]
      new_obj.children.size.should == 3
      new_obj.children[0].parent.should be new_obj
      new_obj.children[0].should be_a Safe::Node
      new_obj.children[0].name.should == "Node"
      new_obj.children[1].should be_a Safe::Dir
      new_obj.children[1].name.should == "Dir"
      new_obj.children[1].children.size.should == 1
      new_obj.children[1].children[0].name.should == "DirNode"
      new_obj.children[1].children[0].parent.should be new_obj.children[1]
      new_obj.children[2].parent.should be new_obj
      new_obj.children[2].should be_a Safe::Entry
      new_obj.children[2].name.should == "title"
      new_obj.children[2].password.inspect.should == "_123456 "
      new_obj.children[2].website.should be_nil
      new_obj.children[2].comment.should be_nil
      new_obj.children[2].tags.should == []
    end
  end

  describe "::from_other" do
    pending "Not tested"
  end
end
