# encoding: utf-8

require "spec_helper"

describe Safe::Tree do
  subject { Safe::Tree.instance }

  # Node
  # Dir < DirNode
  let(:node) { Safe::Node.new("Node") }
  before { dir << dir_node }
  let(:dir) { Safe::Dir.new("Dir") }
  let(:dir_node) { Safe::Node.new("DirNode") }

  before { subject.clear }

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

  describe "#serialize" do
    before do
      #subject << dir
      #subject.current = dir
    end

    it "should serialize the right attributes" do
      subject.serialize.should == <<-EOC
--- !ruby/object:RySafe::Safe::RootDir
name: root
created_at: '2013-01-01T12:13:14'
modified_at: '2013-01-01T12:13:14'
destroyed_at: 
children: []
current: /root
      EOC
    end
  end

  describe "::from_other" do
    pending "Not tested"
  end
end
