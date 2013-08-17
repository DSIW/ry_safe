# encoding: utf-8

require "spec_helper"

describe Path do
  subject { Path.new(path) }
  let(:path) { "/path/to/file" }

  its(:dirname) { should == "/path/to" }
  its(:filename) { should == "file" }

  its(:to_s) { should == "/path/to/file" }
  its(:path) { should == "/path/to/file" }

  describe "#absolute?" do
    pending "Not tested"
  end

  describe "#relative?" do
    pending "Not tested"
  end

  describe "#root?" do
    pending "Not tested"
  end

  describe "#empty?" do
    pending "Not tested"
  end

  describe "#relative_directory?" do
    pending "Not tested"
  end

  describe "#to_node" do
    subject { Path.new("/parent/name").to_node }

    it { should be_a Safe::Node }
    its(:name) { should == "name" }
    its("parent.name") { should == "parent" }
  end

  describe "#to_existing_node_in" do
    let(:root) { Safe::Dir.new("root") }
    let(:dir) { Safe::Dir.new("dir") }

    before { root << dir }

    subject { Path.new("/root/dir").to_existing_node_in(root) }

    it { should be dir }
  end

  context "path == ''" do
    let(:path) { "" }
    its(:dirname) { should == nil }
    its(:filename) { should == nil }
  end

  context "path == /" do
    let(:path) { "/" }
    its(:dirname) { should == "/" }
    its(:filename) { should == nil }
  end

  context "path == /file" do
    let(:path) { "/file" }
    its(:dirname) { should == "/" }
    its(:filename) { should == "file" }
  end

  context "path == .." do
    let(:path) { ".." }
    its(:dirname) { should == ".." }
    its(:filename) { should == nil }
  end

  context "path == ../" do
    let(:path) { "../" }
    its(:dirname) { should == ".." }
    its(:filename) { should == nil }
  end

  context "path == ../../" do
    let(:path) { "../../" }
    its(:dirname) { should == "../.." }
    its(:filename) { should == nil }
  end

  context "path == ." do
    let(:path) { "." }
    its(:dirname) { should == "." }
    its(:filename) { should == nil }
  end

  context "path == test" do
    let(:path) { "test" }
    its(:dirname) { should == nil }
    its(:filename) { should == "test" }
  end
end

describe RelativePath do
  before { Safe::Tree.stub(current: OpenStruct.new(path: "/pwd")) }

  subject { RelativePath.new(relative_path) }
  let(:relative_path) { "path/to" }

  describe "#init" do
    its(:path) { should == relative_path }
    its(:pwd) { should == "/pwd" }
  end

  describe "#to_absolute" do
    subject { RelativePath.new(relative_path).to_absolute }

    it { should be_a AbsolutePath }

    its(:path) { should == "/pwd/path/to" }

    context "starting with ../" do
      let(:relative_path) { "../path/to" }
      its('path') { should == "/path/to" }
    end

    context "starting with ../../" do
      let(:relative_path) { "../../path/to" }
      its(:path) { should == "/path/to" }
    end

    context "starting with ./" do
      let(:relative_path) { "./path/to" }
      its(:path) { should == "/pwd/path/to" }
    end

    context "is /" do
      let(:relative_path) { "/" }
      its(:path) { should == "/root" }
    end

    context "starting with /" do
      let(:relative_path) { "/path/to" }
      its(:path) { should == "/root/path/to" }
    end

    context "starting with /root" do
      let(:relative_path) { "/root/to" }
      its(:path) { should == "/root/to" }
    end
  end

  its(:absolute?) { should be_false }
  its(:relative?) { should be_true }
end

describe AbsolutePath do
  subject { AbsolutePath.new("/path/to/file") }

  its(:absolute?) { should be_true }
  its(:relative?) { should be_false }
end
