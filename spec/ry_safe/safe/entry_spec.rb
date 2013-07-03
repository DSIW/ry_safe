# encoding: utf-8

require "spec_helper"

describe Safe::Entry do

  subject { Safe::Entry.new(title, parent) }
  let(:title) { "title" }
  let(:parent) { nil }

  its(:to_s) { should == "/title" }

  it "should be in root by default" do
    subject.directory.should == nil
  end

  it "should change the directory" do
    dir = Safe::Dir.new("dir")
    subject.directory = dir
    subject.directory.should == dir
    dir.children.should include(subject)
  end

  describe "default data" do
    it "should set and get website" do
      subject.website = "http://example.com"
      subject.website.should == "http://example.com"
    end

    it "should set and get username" do
      subject.username = "username"
      subject.username.should == "username"
    end

    it "should set and get password" do
      subject.password = "123456"
      subject.password.should == Password.new("123456")
    end

    it "should set and get password confirmation" do
      subject.password_confirmation = "123456"
      subject.password_confirmation.should == Password.new("123456")
    end

    it "should be valid if password and password confirmation are equals" do
      subject.password = "123456"
      subject.password_confirmation = "123456"
      subject.should be_valid
    end

    it "should not be valid if password and password confirmation are equals" do
      subject.password = "123456"
      subject.password_confirmation = "12345"
      subject.should_not be_valid
    end

    it "should set and get comment" do
      subject.comment = "comment"
      subject.comment.should == "comment"
    end

    it "should set and get tag" do
      subject.tags = "one,two, three four-five a_b"
      subject.should have(5).tags
      subject.tags.should == %w(one two three four-five a_b).map { |t| Safe::Tag.new(t) }
    end
  end
end
