# encoding: utf-8

require "spec_helper"

describe Commands::DSLCommands do
  subject { Commands::DSLCommands }

  it "commands" do
    subject.commands.should be_a Array
    subject.commands.should have(18).command
    subject.commands[:touch].name.should == 'touch'
    subject.commands[:help].name.should == 'help'
  end
end
