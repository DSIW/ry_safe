# encoding: utf-8

require "spec_helper"

describe Safe::Tree do
  subject { Safe::Tree.instance }

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

  describe "personal working directory" do
    let(:new_pwd) { Safe::Dir.new("new_current_dir") }
    let(:dir_not_in_tree) { Safe::Dir.new("not_in_tree") }

    before do
      Safe::Tree.root.clear
      Safe::Tree.root << new_pwd
    end

    it "should set and get working directory" do
      subject.current = new_pwd
      subject.current.should == new_pwd
    end

    it "should get root if no current is specified" do
      subject.current.should == Safe::Tree.root
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
        subject.current.should == Safe::Tree.root
      end
    end

    describe "#reset_current" do
      before { subject.reset_current }

      it "should reset current" do
        subject.current.should == Safe::Tree.root
      end
    end

    it "should set and get working directory" do
      Safe::Tree.instance.current = new_pwd
      Safe::Tree.instance.current.should == new_pwd
    end
  end
end
