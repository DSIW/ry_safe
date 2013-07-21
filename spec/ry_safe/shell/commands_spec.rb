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

    it "should call method action if " do
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

  describe Commands::MkDir do
    subject { Commands::MkDir.new("dir") }

    its(:command) { should == "mkdir" }
    its(:arguments) { should == ["dir"] }

    it "should create a new entry" do
      tree = Safe::Tree.root
      subject.call
      tree.should have(1).node
      tree.children.first.name.should == "dir"
      tree.children.first.should be_a Safe::Dir
    end

    context "with relative paths and pwd" do
      pending "Not tested"
    end
  end

  describe Commands::ChangeDirectory do
    let(:tree) { Safe::Tree.root }
    let(:dir) { Safe::Dir.new("dir") }
    let(:current) { Safe::Tree.current }

    before do
      Safe::Tree.reset_current
      tree << dir
    end

    subject { Commands::ChangeDirectory.new("/root/dir") }

    its(:command) { should == "cd" }
    its(:arguments) { should == ["/root/dir"] }

    it "should change current working dir to specified directory" do
      subject.call
      current.should be dir
    end
  end

  describe Commands::Move do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Commands::Move.new("/root/from", "/root/to") }

    its(:command) { should == "mv" }
    its(:arguments) { should == ["/root/from", "/root/to"] }

    its(:source) { should be from }
    its(:destination) { should be to }

    it "should move node to specified directory" do
      subject.call

      tree.children.should == [to]
      to.children.should == [from]
    end
  end

  describe Commands::Copy do
    let(:tree) { Safe::Tree.root }
    let(:from) { Safe::Node.new("from") }
    let(:to) { Safe::Dir.new("to") }

    before do
      tree << from
      tree << to
    end

    subject { Commands::Copy.new("/root/from", "/root/to") }

    its(:command) { should == "cp" }
    its(:arguments) { should == ["/root/from", "/root/to"] }

    its(:source) { should be from }
    its(:destination) { should be to }

    it "should copy node to specified directory" do
      subject.call

      tree.children.should == [from, to]
      to.children.should == [from]
    end
  end

  describe Commands::Remove do
    let(:tree) { Safe::Tree.root }
    let(:node) { Safe::Node.new("node") }
    let(:dir) { Safe::Dir.new("dir") }

    before do
      tree << node
      tree << dir
    end

    subject { Commands::Remove.new("/root/node") }

    its(:command) { should == "rm" }
    its(:arguments) { should == ["/root/node"] }

    its(:node) { should be node }

    it "should remove node" do
      removed_node = subject.call

      tree.children.should == [dir]
      removed_node.should be_frozen
      removed_node.parent.should be_nil
    end
  end

  describe Commands::List do
    pending "NotTested"
  end

  describe Commands::ShowEntry do
    pending "NotTested"
  end

  describe Commands::Set do
    subject { Commands::Set.new("entry", "password=123 456") }
    let(:entry) { stub(Safe::Entry) }

    its(:command) { should == "set" }

    it "should set password in entry" do
      subject.should_receive(:relative_path_to_existing_node).with("entry").and_return(entry)

      entry.should_receive("password=").with("123 456").and_return(true)
      STDOUT.should_receive(:puts).with("Saved")

      subject.action
    end
  end

  describe Commands::Get do
    subject { Commands::Get.new("entry", "password") }
    let(:entry) { stub(Safe::Entry) }

    its(:command) { should == "get" }

    it "should get password of entry" do
      subject.should_receive(:relative_path_to_existing_node).with("entry").and_return(entry)

      entry.should_receive("password").and_return("123 456")
      STDOUT.should_receive(:puts).with("123 456")

      subject.action
    end
  end

  describe Commands::WorkingDirectory do
    subject { Commands::WorkingDirectory.new }

    its(:command) { should == "pwd" }

    it "should print current directory" do
      subject.should_receive(:current_path).and_return("/current/pwd")
      STDOUT.should_receive(:puts).with("/current/pwd")

      subject.action
    end

    it "should get current path of tree" do
      NodePresenter.any_instance.should_receive(:path).and_return("/current/pwd")
      subject.current_path.should == "/current/pwd"
    end
  end

  describe Commands::Clear do
    subject { Commands::Clear.new }

    its(:command) { should == "clear" }

    it "should print as many new lines as terminal window is height" do
      STDOUT.should_receive(:puts).with("\n"*40)
      subject.action
    end
  end

  describe Commands::Rename do
    subject { Commands::Rename.new("entry", "new_name") }
    let(:node) { Struct.new(:name).new }

    its(:command) { should == "rename" }
    its(:new_name) { should == "new_name" }

    it "should set new name to node" do
      subject.should_receive(:relative_path_to_existing_node).with("entry").and_return(node)
      node.should_receive(:name=).with("new_name").and_return(true)
      STDOUT.should_receive(:puts).with("Renamed to new_name")

      subject.action
    end
  end

  describe Commands::Exit do
    subject { Commands::Exit.new }

    its(:command) { should == "exit" }

    it "should exit RySafe" do
      expect { subject.action }.to raise_error SystemExit
    end
  end

  describe Commands::Help do
    subject { Commands::Help.new }

    let(:commands) do
      [
        stub(command: 'command_one', help_summary: "Description of command one"),
        stub(command: 'command_two', help_summary: "Description of command two")
      ]
    end

    its(:command) { should == "help" }

    it "should print each command with help summary" do
      Commands::Commands.should_receive(:all).and_return(commands)
      message = <<-MESSAGE
All available commands are:

command_one: Description of command one
command_two: Description of command two
      MESSAGE
      STDOUT.should_receive(:puts).with message.chomp

      subject.action
    end
  end

  describe Commands::Version do
    subject { Commands::Version.new }

    its(:command) { should == "version" }

    it "should print current version number" do
      STDOUT.should_receive(:puts).with("Version: #{RySafe::VERSION}")

      subject.action
    end
  end

  describe Commands::PasswordGenerator do
    subject { Commands::PasswordGenerator.new("8", "2" , "char_class=alnum") }

    its(:command) { should == "gen_passwords" }
    its(:length) { should == 8 }
    its(:count) { should == 2 }
    its(:options) { should == {char_class: 'alnum'} }

    it "should generate passwords" do
      # TODO: Add parameter checks for PasswordGenerator.new and #genrate
      subject.stub(passwords: [Password.new("12345678"), Password.new("12345679")])
      STDOUT.should_receive(:puts).with("12345678\n12345679")

      subject.action
    end
  end

  describe Commands::Dispatcher do
    subject { Commands::Dispatcher.new("mv /from \"/to/other path\" ") }

    its(:key) { should == "mv" }
    its(:arguments) { should == ["/from", "/to/other path"] }
    its(:command_class) { should == Commands::Move }
    its(:command) { should be_a Commands::Move }
    its("command.arguments") { should == ["/from", "/to/other path"] }

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
