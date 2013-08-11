# encoding: utf-8

require "spec_helper"

describe Safe::Dir do

  subject { Safe::Dir.new(name, parent) }
  let(:name) { "NodeName" }
  let(:parent) { nil }

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

  its(:children) { should == [] }

  describe "#children?" do
    its(:children?) { should be_false }

    context "with children" do
      before { subject << node }

      its(:children?) { should be_true }
    end
  end

  describe "#empty?" do
    its(:empty?) { should be_true }

    context "with children" do
      before { subject << node }

      its(:empty?) { should be_false }
    end
  end

  describe "#<<" do
    before do
      subject << node
      subject << dir
    end

    it "should add two children" do
      subject.children.size == 2
      subject.children.first.name.should == "Node"
      subject.children[1].name.should == "Dir"
      subject.children[1].children.first.name.should == "DirNode"
    end

    it "should not add already existing child" do
      subject.should include Safe::Dir.new("Dir")
      new_dir = Safe::Dir.new("Dir")
      new_dir.parent.should_not == subject
      expect { subject << new_dir }.to raise_error Error::AlreadyExist
      new_dir.parent.should_not == subject
    end

    it "should update parents" do
      subject.children.first.parent.should == subject
      subject.children[1].parent.should == subject
      subject.children[1].children.first.parent.should == dir
    end
  end

  describe "#size" do
    its(:size) { should == 0 }

    context "with one child" do
      before { subject << node }

      its(:size) { should == 1 }
    end
  end

  describe "#resursive_size" do
    let(:new_dir) { Safe::Dir.new("new_dir") }
    its(:recursive_size) { should == 0 }

    context "with one child" do
      before { subject << new_dir }

      its(:recursive_size) { should == 1 }

      context "with one children which has one child" do
        before { new_dir << Safe::Node.new("childchild") }
        before { new_dir << Safe::Node.new("childchild2") }

        its(:recursive_size) { should == 3 }
      end
    end
  end

  describe "#siblings" do
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:node1) { Safe::Node.new("N1") }
    let(:dir2node1) { Safe::Node.new("D2N1") }
    subject(:dir3) { Safe::Dir.new("me") }
    # D1 < D2
    # D1 < D2 < D2N1
    # D1 < D3
    # D1 < N1

    before :each do
      dir1 << dir2
      dir2 << dir2node1
      dir1 << dir3
      dir1 << node1
    end

    its(:siblings) { should == [dir2, node1] }

    context "should return empty array if no parent is set" do
      subject { Safe::Dir.new("no_parent") }

      its(:siblings) { should == [] }
    end
  end

  describe "#dirs" do
    let(:node1) { Safe::Node.new("N1") }
    let(:node2) { Safe::Node.new("N2") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:d2n1) { Safe::Node.new("D2N1", dir2) }
    # N1
    # N2
    # D1
    # D2 < D2N1

    before :each do
      subject << node1
      subject << node2
      subject << dir1
      subject << dir2
    end

    its(:dirs) { should == [dir1, dir2] }
  end

  describe "#entries" do
    let(:node1) { Safe::Entry.new("N1") }
    let(:node2) { Safe::Entry.new("N2") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:d2n1) { Safe::Entry.new("D2N1", dir2) }
    # N1
    # N2
    # D1
    # D2 < D2N1

    before :each do
      subject << node1
      subject << node2
      subject << dir1
      subject << dir2
    end

    its(:entries) { should == [node1, node2] }
  end

  describe "#find" do
    let(:node1) { Safe::Node.new("N1") }
    let(:node2) { Safe::Node.new("N2") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:d2n1) { Safe::Node.new("N1") }

    before do
      subject << node1
      subject << node2
      subject << dir1
      subject << dir2
      dir2 << d2n1
      # N1
      # N2
      # D1
      # D2 < D2N1
    end

    it "should recursively find" do
      subject.find("N1").should == [node1, d2n1]
    end
  end

  describe "#dup" do
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:d1n1) { Safe::Node.new("N1") }

    before do
      subject << node1
      subject << dir1
      dir1 << d1n1
      # N1
      # D1 < D1N1
    end

    its(:dup) { should be_a Safe::Dir }
    it "should duplicate objects recursive" do
      duplicate = subject.dup
      duplicate.children.first.should_not be node1
      duplicate.children.last.should_not be dir1
      duplicate.children.last.children.first.should_not be d1n1
    end
  end

  describe "#include" do
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }

    before { subject << node1 }

    it "should include node1 and dir1" do
      subject.should include node1
      subject.should_not include dir1
    end
  end

  describe "#clear" do
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }

    before do
      subject << node1
      subject << dir1
      subject.should include node1
      subject.should include dir1
    end

    it "should remove all children" do
      subject.clear
      subject.should have(0).children
    end
  end

  describe "#delete" do
    let(:node1) { Safe::Node.new("N1") }

    before do
      subject << node1
      subject.should include node1
    end

    it "should delete node from children" do
      subject.delete(node1)
      subject.should_not include node1
      subject.should have(0).children
    end
  end

  describe "#[]" do
    let(:node1) { Safe::Node.new("N1") }

    before do
      subject << node1
      subject.should include node1
    end

    it "should get node node1" do
      subject["N1"].should be node1
    end

    it "should return nil if node is not a child" do
      subject["node_does_not_exist"].should be_nil
    end
  end

  describe "#serialize" do
    before do
      subject << node
      subject << dir
      subject << entry
    end

    it "should serialize the right attributes" do
      subject.serialize.should == <<-EOC
--- !ruby/object:RySafe::Safe::Dir
name: NodeName
created_at: '2013-01-01T12:13:14'
modified_at: '2013-01-01T12:13:14'
destroyed_at: 
children:
- !ruby/object:RySafe::Safe::Node
  name: Node
  created_at: '2013-01-01T12:13:14'
  modified_at: '2013-01-01T12:13:14'
  destroyed_at: 
- !ruby/object:RySafe::Safe::Dir
  name: Dir
  created_at: '2013-01-01T12:13:14'
  modified_at: '2013-01-01T12:13:14'
  destroyed_at: 
  children:
  - !ruby/object:RySafe::Safe::Node
    name: DirNode
    created_at: '2013-01-01T12:13:14'
    modified_at: '2013-01-01T12:13:14'
    destroyed_at: 
- !ruby/object:RySafe::Safe::Entry
  name: title
  created_at: '2013-01-01T12:13:14'
  modified_at: '2013-01-01T12:13:14'
  destroyed_at: 
  username: UserName
  password: '_123456 '
  website: 
  comment: 
  tags: !ruby/array:RySafe::Safe::Tags []
      EOC
    end
  end

  describe "#deserialize" do
    it "should deserialize the right attributes" do
      new_obj = subject.deserialize <<-EOC
--- !ruby/object:RySafe::Safe::Dir
name: NodeName
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
      EOC

      new_obj.name.should == "NodeName"
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
end
