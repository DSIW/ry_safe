# encoding: utf-8

require "spec_helper"

describe Util::PresenterHelper do
  include Util::PresenterHelper

  describe "#colorize" do
    pending "Not implemented"
  end

  describe "#pluralize" do
    it "should pluralize if number is not 1" do
      pluralize(-2, "singular", "plural").should == "-2 plural"
      pluralize(-1, "singular", "plural").should == "-1 singular"
      pluralize(0, "singular", "plural").should == "0 plural"
      pluralize(1, "singular", "plural").should == "1 singular"
      pluralize(2, "singular", "plural").should == "2 plural"
      pluralize(2, "singular").should == "2 singulars"
    end
  end

  describe "#truncate" do
    it "should truncate with specified number and max length" do
      truncate("abc", 10).should == "abc"
      truncate("abcdefghij", 10).should == "abcdefghij"
      truncate("abcdefghi", 10).should == "abcdefghi"
      truncate("abcdefgh", 10).should == "abcdefgh"
      truncate("abcdefg", 10).should == "abcdefg"
      truncate("abcdefghijk", 10).should == "abcdefg..."
      truncate("abcdefghijkl", 10).should == "abcdefg..."
      truncate("abcdefghijklm", 10).should == "abcdefg..."
      truncate("abcdefghijklm", 10, "..").should == "abcdefgh.."
      truncate("abcdefghijklm", 10, ".").should == "abcdefghi."
    end
  end

  describe "#align" do
    it "should truncate on left side and rjust on right side" do
      align("left", "right", 15).should        == "left      right"
      align("left_abcdefghij", nil, 15).should  == "left_abcdefghij"
      align("", "left_abcdefghij", 15).should  == "left_abcdefghij"
      align("left_abcdefghij", "", 15).should  == "left_abcdefghij"
      align("left_abcdefgh", ".", 15).should   == "left_abcdefgh ."
      align("left_abcd", "right", 15).should   == "left_abcd right"
      align("left_abcd_", "right", 15).should  == "left_a... right"
      align("left_abcd", "_right", 15).should  == "left_... _right"
      align("left_abcd", "__right", 15).should == "left... __right"
      align("left_abcd", "__right", 15, "||").should == "lef...||__right"
    end
  end

  describe "#format_time" do
    it "should format YYYY-MM-DD HH:MM:SS" do
      format_time(DateTime.new(2013,01,01,12,00,00)).should == "2013-01-01 12:00:00"
    end
  end

  describe "#remove_root" do
    it "should remove /root/ from path" do
      remove_root("/").should == "/"
      remove_root("root").should == "root"
      remove_root("/root").should == "/"
      remove_root("/root/").should == "/"
      remove_root("/root/dir").should == "/dir"
    end
  end
end
