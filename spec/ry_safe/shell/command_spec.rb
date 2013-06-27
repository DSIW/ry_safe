# encoding: utf-8

require "spec_helper"

describe Command::Base do
  subject { Command::Base.new("touch file") }

  its(:command) { should == "touch" }
  its(:arguments) { should == ["file"] }
  its(:humand_readable_command) { should == "Touch" }

  it "should call method action if " do
    subject.should_receive(:action)
    subject.call
  end
end
