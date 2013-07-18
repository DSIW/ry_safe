#!/usr/bin/env ruby
# encoding: utf-8

require "spec_helper"

describe Commands::DSL do
  module AllCommands
    extend Commands::DSL

    command :touch do |c|
      c.help_summary { "Help summary" }
    end

    command :echo do |c|
      c.action { |*string| puts "Hello #{string[0]}" }
    end

    command :cp do |c|
      c.action { |from, to| puts "cp #{from} #{to}" }
    end

    command :add do |c|
      c.argument(0) { lambda { |arg| arg.to_i } }
      c.argument(1) { lambda { |arg| arg.to_i } }
      c.action { |a, b| puts a + b }
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

  it "should add command to collection commands" do
    AllCommands.should have(4).commands
    touch.should be_a Commands::DSL::CommandBuilder
    AllCommands.commands.map(&:name).should == ["touch", "echo", "cp", "add"]
  end

  it "should get name of command in yield variable" do
    expect { |b| AllCommands.command(:touch, &b) }.to yield_with_args(Commands::DSL::CommandBuilder)
  end

  it "should set help_summary in command block" do
    touch.help_summary.should == "Help summary"
    echo.help_summary.should == "Default summary"
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
    STDOUT.should_receive(:puts).with("Default")
    touch.call
  end

  it "should convert specified arguments with a specified function" do
    STDOUT.should_receive(:puts).with(3)
    add.call(1, 2)
  end

  #it "should convert builder to command" do
    #cp.to_command.should == Commands::Command
  #end
end
