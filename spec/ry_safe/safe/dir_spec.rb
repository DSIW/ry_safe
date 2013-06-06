# encoding: utf-8

require "spec_helper"

describe Safe::Dir do

  subject { Safe::Dir.new(name, parent) }
  let(:name) { "NodeName" }
  let(:parent) { nil }

  let(:node) { Safe::Node.new("Node") }
  let(:dir) { Safe::Dir.new("Dir") }
  before { dir << dir_node }
  let(:dir_node) { Safe::Node.new("DirNode") }
  # Node
  # Dir < DirNode

  its(:children) { should == [] }

  describe "#children?" do
    its(:children?) { should be_false }

    context "with children" do
      before { subject.children << node }

      its(:children?) { should be_true }
    end
  end

  describe "#empty?" do
    its(:empty?) { should be_true }

    context "with children" do
      before { subject.children << node }

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
end
