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
    pending "Not implemented"
  end

  describe "#align" do
    pending "Not implemented"
  end
end
