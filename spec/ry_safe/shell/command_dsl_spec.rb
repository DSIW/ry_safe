# encoding: utf-8

require "spec_helper"

describe Commands::DSL do
  module Util::CommandHelper
    module_function

    def to_i(arg)
      arg.to_i
    end
  end

  module AllCommands
    extend Commands::DSL

    command :touch do |c|
      c.help_summary { "Help summary" }
    end

    # should be overwritten by the following echo command
    command :echo do |c|
      c.action { |string| puts "Should never be called" }
    end

    command :echo do |c|
      c.action { |*string| puts "Hello #{string[0]}" }
    end

    command :cp do |c|
      c.argument(0)
      c.action { |from, to| puts "cp #{from} #{to}" }
    end

    command :add do |c|
      c.argument(0) { |arg| arg.to_i }
      c.argument(1) { |arg| arg.to_i }
      c.action { |a, b| puts a + b }
    end

    command :add_with_helper do |c|
      c.argument(0, :to_i)
      c.argument(1, :to_i)
      c.action { |a, b| puts a + b }
    end

    command :multi_string do |c|
      c.argument(0) { |arg| arg.to_s }
      c.argument(1) { |arg| arg.to_i }
      c.action { |a, b| puts a * b }
    end
  end

  def touch
    AllCommands.commands[:touch]
  end

  def echo
    AllCommands.commands[:echo]
  end

  def cp
    AllCommands.commands[:cp]
  end

  def add
    AllCommands.commands[:add]
  end

  def add_with_helper
    AllCommands.commands[:add_with_helper]
  end

  def multi_string
    AllCommands.commands[:multi_string]
  end

  it "should add command to collection commands" do
    AllCommands.should have(6).commands
    touch.should be_a Commands::DSL::CommandBuilder
    AllCommands.commands.map(&:name).should == ["touch", "echo", "cp", "add", "add_with_helper", "multi_string"]
  end

  it "should set help_summary in command block" do
    AllCommands.commands[:touch].help_summary.should == "Help summary"
  end

  it "should set help_summary in command block" do
    echo.help_summary.should == Commands::DSL::CommandBuilder::DEFAULT_SUMMARY
  end

  it "should set action" do
    echo.action.should be_a Proc
  end

  it "should call action" do
    STDOUT.should_receive(:puts).with("Hello ")
    echo.call
  end

  it "should call action with arguments" do
    STDOUT.should_receive(:puts).with("Hello Peter")
    echo.call("Peter")
  end

  it "should call action with many arguments" do
    STDOUT.should_receive(:puts).with("cp from to")
    cp.call("from", "to")
  end

  it "should call default action" do
    touch.action.should == Commands::DSL::CommandBuilder::DEFAULT_ACTION
    touch.call
  end

  it "should convert specified arguments with a specified function" do
    STDOUT.should_receive(:puts).with(3)
    add.call("1", "2")
  end

  it "should convert specified arguments with a specified function" do
    STDOUT.should_receive(:puts).with(3)
    add_with_helper.call("1", "2")
  end

  it "should convert specified arguments with a specified function" do
    STDOUT.should_receive(:puts).with("111")
    multi_string.call("1", "3")
  end
end
