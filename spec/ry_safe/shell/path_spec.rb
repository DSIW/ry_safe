# encoding: utf-8

require "spec_helper"

describe Path do
  subject { Path.new("/path/to/file") }

  its(:to_s) { should == "/path/to/file" }
  its(:path) { should == "/path/to/file" }

  it "should raise exceptions for absolute and relative" do
    expect { subject.absolute? }.to raise_error StandardError, /not implemented/i
    expect { subject.relative? }.to raise_error StandardError, /not implemented/i
  end

  describe "#to_node" do
    subject { Path.new("/parent/name").to_node }

    it { should be_a Safe::Node }
    its(:name) { should == "name" }
    its("parent.name") { should == "parent" }
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

    context "with ../" do
      let(:relative_path) { "../path/to" }
      its('path') { should == "/path/to" }
    end

    context "with ../../" do
      let(:relative_path) { "../../path/to" }
      its(:path) { should == "/path/to" }
    end

    context "with ./" do
      let(:relative_path) { "./path/to" }
      its(:path) { should == "/pwd/path/to" }
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
