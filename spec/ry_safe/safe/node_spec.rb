# encoding: utf-8

require "spec_helper"

describe Safe::Node do

  subject { Safe::Node.new(name, parent) }
  let(:name) { "NodeName" }
  let(:parent) { Safe::Node.new("Parent", nil) }

  describe "#init" do
    it "should set name" do
      subject.name.should == "NodeName"
    end

    it "should set parent" do
      subject.parent.should == parent
    end

    context "without name" do
      it "should raise an error" do
        expect { Safe::Node.new(nil, nil) }.to raise_error ArgumentError
      end
    end

    context "without parent" do
      subject { Safe::Node.new(name) }

      it "should set parent as nil" do
        subject.parent.should be_nil
      end
    end
  end

  describe "#parents" do
    its(:parents) { should == [parent] }

    context "without parent" do
      subject { parent }
      its(:parents) { should == [] }
    end

    context "with two parents" do
      let(:parent) { Safe::Node.new("Parent1", grand_parent) }
      let(:grand_parent) { Safe::Node.new("Parent2") }

      its(:parents) { should == [parent, grand_parent] }
    end
  end

  describe "::from_path" do
    context "path == /" do
      subject { Safe::Node.from_path("/") }

      it "should raise an error" do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context "path == /NodeName" do
      subject { Safe::Node.from_path("/NodeName") }

      its(:name) { should == "NodeName" }
      its(:root?) { should be_true }
    end

    context "path == /Parent/NodeName" do
      subject { Safe::Node.from_path("/Parent/NodeName") }

      its(:name) { should == "NodeName" }
      its(:parent?) { should be_true }
      its('parent.name') { should == "Parent" }
      its('parent.root?') { should be_true }
    end
  end

  describe "#root?" do
    its(:root?) { should be_false }

    context "without parent" do
      subject { parent }

      its(:root?) { should be_true }
    end
  end

  describe "#parent?" do
    its(:parent?) { should be_true }

    context "without parent" do
      subject { parent }

      its(:parent?) { should be_false }
    end
  end

  describe "#to_s" do
    its(:to_s) { should == "/Parent/NodeName" }
  end

  describe "#path" do
    its(:path) { should == "/Parent/NodeName" }

    context "without parent" do
      subject { parent }

      its(:path) { should == "/Parent" }
    end
  end

  describe "#<=>" do
    let(:parent) { Safe::Node.new("Parent") }
    let(:parent2) { Safe::Node.new("Parent2") }
    let(:a1) { Safe::Node.new("A", parent) }
    let(:a2) { Safe::Node.new("A", parent2) }

    it "should be equals" do
      a1.should == a2
    end
  end

  describe "#===" do
    it "should compare name with pattern" do
      (subject === "NodeName").should be_true
      (subject === "Parent").should be_false
    end
  end

  describe "#hash" do
    it "should be an fixnum" do
      subject.hash.should be_a Fixnum
    end

    it "should be the hash of name" do
      subject.hash.should == name.hash
    end
  end

  describe "#eql?" do
    it "should be true if names are equals" do
      subject.should be_eql Safe::Node.new(name)
    end

    it "should not be false if names aren't equals" do
      subject.should_not be_eql Safe::Node.new("different")
    end
  end
end