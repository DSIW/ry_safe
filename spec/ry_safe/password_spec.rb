# encoding: utf-8

require "spec_helper"

describe Password do

  subject { Password.new(string) }
  let(:string) { "123456" }

  its(:length) { should == 6 }
  its(:password) { should == "123456" }

  it "should hide password by default" do
    subject.to_s.should == "******"
  end

  it "should show password after setting safe" do
    Password.visible!
    subject.to_s.should == "123456"
  end

  it "should hide password after setting unsafe" do
    Password.visible!
    subject.to_s.should == "123456"
    Password.hidden!
    subject.to_s.should == "******"
  end

  it "should be comparable with other passwords" do
    Password.new("1234").should == Password.new("1234")
    Password.new("12345").should_not == Password.new("1234")
    Password.new("1234").should_not == Password.new("12345")
  end
end
