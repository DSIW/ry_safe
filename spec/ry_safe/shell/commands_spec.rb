# encoding: utf-8

require "spec_helper"

describe Commands do
  before do
    Safe::Tree.root.clear
  end

  describe Commands::Base do
    subject { Commands::Base.new("touch", "file") }

    its(:command) { should == "touch" }
    its(:arguments) { should == ["file"] }
    its(:human_readable_command) { should == "Touch" }

    it "should call method action" do
      subject.should_receive(:action)
      subject.call
    end

    describe "#absolute_path" do
      pending "Not tested"
    end

    describe "#relative_path_to_node" do
      pending "Not tested"
    end

    describe "#relative_path_to_existing_node" do
      pending "Not tested"
    end
  end

  describe "Commands::Touch" do
    subject { Commands::Commands.all.to_hash['touch'] }

    its(:command) { should == "touch" }

    it "should create a new entry" do
      tree = Safe::Tree.root
      subject.call("file")
      tree.should have(1).node
      tree.children.first.name.should == "file"
      tree.children.first.should be_a Safe::Entry
    end

    context "with relative paths and pwd" do
      pending "Not tested"
    end
  end

  describe "Commands::MkDir" do
    subject { Commands::Commands.all.to_hash['mkdir'] }

    its(:command) { should == "mkdir" }

    it "should create a new entry" do
      tree = Safe::Tree.root
      subject.call("dir")
      tree.should have(1).node
      tree.children.first.name.should == "dir"
      tree.children.first.should be_a Safe::Dir
    end

    context "with relative paths and pwd" do
      pending "Not tested"
    end
  end

  describe "Commands::ChangeDirectory" do
    let(:tree) { Safe::Tree.root }
    let(:dir) { Safe::Dir.new("dir") }
    let(:current) { Safe::Tree.current }

    before do
      Safe::Tree.reset_current
      tree << dir
    end

    subject { Commands::Commands.all.to_hash['cd'] }

    its(:command) { should == "cd" }

    it "should change current working dir to specified directory" do
      subject.call("/root/dir")
      current.should be dir
    end
  end

  describe "Commands::Move" do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Commands::Commands.all.to_hash['mv'] }

    its(:command) { should == "mv" }

    it "should move node to specified directory" do
      subject.call("/root/from", "/root/to")

      tree.children.should == [to]
      to.children.should == [from]
    end
  end

  describe "Commands::Copy" do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Commands::Commands.all.to_hash['cp'] }

    its(:command) { should == "cp" }

    it "should copy node to specified directory" do
      subject.call("/root/from", "/root/to")

      tree.children.should == [from, to]
      to.children.should == [from]
    end
  end

  describe "Commands::Remove" do
    let(:tree) { Safe::Tree.root }
    let(:node) { Safe::Node.new("node") }
    let(:dir) { Safe::Dir.new("dir") }

    before do
      tree << node
      tree << dir
    end

    subject { Commands::Commands.all.to_hash['rm'] }

    its(:command) { should == "rm" }

    it "should remove node" do
      removed_node = subject.call("/root/node")

      tree.children.should == [dir]
      removed_node.should be_frozen
      removed_node.parent.should be_nil
    end
  end

  describe "Commands::List" do
    pending "NotTested"
  end

  describe "Commands::ShowEntry" do
    pending "NotTested"
  end

  describe "Commands::Set" do
    subject { Commands::Commands.all.to_hash['set'] }
    let(:entry) { stub(Safe::Entry) }

    its(:command) { should == "set" }

    it "should set password in entry" do
      Util::CommandHelper.should_receive(:relative_path_to_existing_node).with("entry").and_return(entry)

      entry.should_receive("password=").with("123 456").and_return(true)
      STDOUT.should_receive(:puts).with("Saved")

      subject.call("entry", "password=123 456")
    end
  end

  describe "Commands::Get" do
    subject { Commands::Commands.all.to_hash['get'] }
    let(:entry) { stub(Safe::Entry) }

    its(:command) { should == "get" }

    it "should get password of entry" do
      Util::CommandHelper.should_receive(:relative_path_to_existing_node).with("entry").and_return(entry)

      entry.should_receive("password").and_return("123 456")
      STDOUT.should_receive(:puts).with("123 456")

      subject.call("entry", "password")
    end
  end

  describe "Commands::WorkingDirectory" do
    subject { Commands::Commands.all.to_hash['pwd'] }

    its(:command) { should == "pwd" }

    it "should print current directory" do
      TreePresenter.any_instance.should_receive(:path).and_return("/current/pwd")
      STDOUT.should_receive(:puts).with("/current/pwd")

      subject.call
    end
  end

  describe "Commands::Clear" do
    subject { Commands::Commands.all.to_hash['clear'] }

    its(:command) { should == "clear" }

    it "should print as many new lines as terminal window is height" do
      STDOUT.should_receive(:puts).with("\n"*40)
      subject.call
    end
  end

  describe "Commands::Rename" do
    subject { Commands::Commands.all.to_hash['rename'] }
    let(:node) { Struct.new(:name).new }

    its(:command) { should == "rename" }
    #its(:new_name) { should == "new_name" }

    it "should set new name to node" do
      Util::CommandHelper.should_receive(:relative_path_to_existing_node).with("entry").and_return(node)
      node.should_receive(:name=).with("new_name").and_return(true)
      STDOUT.should_receive(:puts).with("Renamed to new_name")

      subject.call("entry", "new_name")
    end
  end

  describe "Commands::Exit" do
    subject { Commands::Commands.all.to_hash['exit'] }

    its(:command) { should == "exit" }

    it "should exit RySafe" do
      expect { subject.call }.to raise_error SystemExit
    end
  end

  describe "Commands::Help" do
    pending "NotTested"
    #subject { Commands::Commands.all.to_hash['help'] }

    #let(:commands) do
      #[
        #stub(command: 'command_one', help_summary: "Description of command one"),
        #stub(command: 'command_two', help_summary: "Description of command two")
      #]
    #end

    #its(:command) { should == "help" }

    #it "should print each command with help summary" do
      #Commands::Commands.should_receive(:all).and_return(commands)
      #message = <<-MESSAGE
#All available commands are:

#command_one: Description of command one
#command_two: Description of command two
      #MESSAGE
      #STDOUT.should_receive(:puts).with message.chomp

      #subject.call
    #end
  end

  describe "Commands::Version" do
    subject { Commands::Commands.all.to_hash['version'] }

    its(:command) { should == "version" }

    it "should print current version number" do
      STDOUT.should_receive(:puts).with("Version: #{RySafe::VERSION}")

      subject.call
    end
  end

  describe "Commands::PasswordGenerator" do
    subject { Commands::Commands.all.to_hash['gen_passwords'] }

    its(:command) { should == "gen_passwords" }

    it "should generate passwords" do
      generator = mock(:generator)
      RySafe::PasswordGenerator.should_receive(:new).with(8, char_class: 'alnum').and_return(generator)
      generator.should_receive(:generate).with(2).and_return([Password.new("12345678"), Password.new("12345678")])

      STDOUT.should_receive(:puts).with("12345678\n12345678")

      subject.call("8", "2", "char_class=alnum")
    end
  end

  describe Commands::Dispatcher do
    subject { Commands::Dispatcher.new("mv /from \"/to/other path\" ") }

    its(:key) { should == "mv" }
    its(:arguments) { should == ["/from", "/to/other path"] }

    it "should get the right commands" do
      commands = Commands::Dispatcher.commands
      commands.should have(18).commands
      commands.should include "touch"
      commands.should include "mkdir"
      commands.should include "cd"
      commands.should include "cp"
      commands.should include "mv"
      commands.should include "rm"
      commands.should include "ls"
      commands.should include "cat"
      commands.should include "set"
      commands.should include "get"
      commands.should include "pwd"
      commands.should include "clear"
      commands.should include "rename"
      commands.should include "exit"
      commands.should include "reload!"
      commands.should include "help"
      commands.should include "version"
      commands.should include "gen_passwords"
    end

    context "without arguments" do
      subject { Commands::Dispatcher.new("mv") }

      its(:key) { should == "mv" }
      its(:arguments) { should == [] }
    end

    context "command class key does not exist" do
      subject { Commands::Dispatcher.new("no") }

      its(:key) { should == "no" }
      it "should raise" do
        expect { subject.command_class }.to raise_error Error::NoCommand
        expect { subject.command }.to raise_error Error::NoCommand
        expect { subject.call }.to raise_error Error::NoCommand
      end
    end
  end

  describe Commands::Commands do
    describe "::all" do
      it "should get all commands from register" do
        commands = [stub(command: "command_one")]
        dsl_commands = [stub(command: "command_two")]
        Commands::Base.should_receive(:register).and_return(commands)
        Commands::DSLCommands.should_receive(:commands).and_return(dsl_commands)

        Commands::Commands.all.should == [commands, dsl_commands].flatten
      end
    end

    describe "::all_registered" do
      it "should get all commands from register" do
        commands = [stub(command: "command_one")]
        Commands::Base.should_receive(:register).and_return(commands)

        Commands::Commands.all_registered.should == commands
      end
    end

    describe "::all_from_dsl" do
      it "should get all commands from DSL" do
        commands = [stub(command: "command_one")]
        Commands::DSLCommands.should_receive(:commands).and_return(commands)

        Commands::Commands.all_from_dsl.should == commands
      end
    end

    describe "#to_hash" do
      it "should convert commands to hash with key command" do
        one = stub(command: 'command_one', help_summary: "Description of command one")
        two = stub(command: 'command_two', help_summary: "Description of command two")
        commands = [one, two]

        Commands::Commands.new(commands).to_hash.should == {
          "command_one" => one,
          "command_two" => two,
        }
      end
    end
  end
end
