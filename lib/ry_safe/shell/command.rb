# encoding: utf-8

require 'shellwords'

class Commands < Array; end

module RySafe::Command
  class Base
    extend Util::Register

    attr_reader :command, :arguments

    def initialize(*args)
      @command = command || args.shift
      @arguments = args
    end

    def call
      action
    end

    def action
      raise "No action in Command::Base"
    end

    def humand_readable_command
      command[0].upcase + command[1..-1]
    end

    def self.help_summary
      nil
    end

    protected

    def absolute_path(relative_path, pwd = Safe::Tree.current.path)
      RelativePath.new(relative_path, pwd).to_absolute
    end

    def relative_path_to_node(relative_path, pwd = Safe::Tree.current.path)
      absolute_path(relative_path, pwd).to_node
    end

    def relative_path_to_existing_node(relative_path, pwd = Safe::Tree.current)
      absolute_path(relative_path, pwd.path).to_existing_node_in(Safe::Tree.root)
    end
  end

  class Touch < Base
    def command
      "touch"
    end

    def action
      Safe::Tree.current << Safe::Entry.new(arguments.first)
    end

    def self.help_summary
      "Create an new entry in current directory"
    end
  end

  class MkDir < Base
    def command
      "mkdir"
    end

    def action
      Safe::Tree.current << Safe::Dir.new(arguments.first)
    end

    def self.help_summary
      "Create an new directory in current directory"
    end
  end

  class ChangeDirectory < Base
    def command
      "cd"
    end

    def action
      Safe::Tree.current = node
    end

    def path
      arguments[0]
    end

    def node
      relative_path_to_existing_node(path)
    end

    def self.help_summary
      "Change current directory to the specified directory"
    end
  end

  module Movement
    def source
      relative_path_to_existing_node(arguments[0])
    end

    def destination
      relative_path_to_existing_node(arguments[1])
    end
  end

  class Copy < Base
    include Movement

    def command
      "cp"
    end

    def action
      Util::NodeHandler.copy(source, destination)
    end

    def self.help_summary
      "Copy item to another directory"
    end
  end

  class Move < Base
    include Movement

    def command
      "mv"
    end

    def action
      Util::NodeHandler.move(source, destination)
    end

    def self.help_summary
      "Move item to another directory"
    end
  end

  class Remove < Base
    def command
      "rm"
    end

    def action
      Util::NodeHandler.remove(node)
    end

    def node
      relative_path_to_existing_node(arguments[0])
    end

    def self.help_summary
      "Remove directory or entry"
    end
  end

  class List < Base
    def command
      "ls"
    end

    def action
      puts node.presenter.children
    end

    def node
      relative_path_to_existing_node(arguments[0] || ".")
    end

    def self.help_summary
      "List all items in current directory"
    end
  end

  class ShowEntry < Base
    def command
      "cat"
    end

    def action
      puts entry.presenter.content
    end

    def entry
      relative_path_to_existing_node(arguments[0])
    end

    def self.help_summary
      "Show specified entry"
    end
  end

  class Set < Base
    def command
      "set"
    end

    def action
      node.send("#{attribute}=", value)
      puts "Saved"
    end

    def node
      relative_path_to_existing_node(arguments[0])
    end

    def attribute
      setting.first
    end

    def value
      setting.last
    end

    def setting
      arguments[1].split('=')
    end

    def self.help_summary
      "Set option to specified entry"
    end
  end

  class Get < Base
    def command
      "get"
    end

    def action
      puts node.send(attribute)
    end

    def node
      relative_path_to_existing_node(arguments[0])
    end

    def attribute
      arguments[1]
    end

    def self.help_summary
      "Read option from specified entry"
    end
  end

  class WorkingDirectory < Base
    def command
      "pwd"
    end

    def action
      puts Safe::Tree.current.presenter.path
    end

    def self.help_summary
      "Print the current directory path"
    end
  end

  class Clear < Base
    def command
      "clear"
    end

    def action
      puts "\n"*40
    end

    def self.help_summary
      "Clear console"
    end
  end

  class Rename < Base
    def command
      "rename"
    end

    def action
      node.name = new_name
      puts "Renamed to #{new_name}"
    end

    def node
      relative_path_to_existing_node(arguments[0])
    end

    def new_name
      arguments[1]
    end

    def self.help_summary
      "Rename current entry oder directory"
    end
  end

  class Exit < Base
    def command
      "exit"
    end

    def action
      exit
    end

    def self.help_summary
      "Exit RySafe console"
    end
  end

  class Help < Base
    def command
      "help"
    end

    def action
      puts "All available commands are:\n"
      puts commands
    end

    def commands
      Dispatcher.commands_hash.map do |name, command|
        "#{name}: #{command.help_summary}"
      end.join("\n")
    end

    def self.help_summary
      "Show this help message"
    end
  end

  class Version < Base
    def command
      "version"
    end

    def action
      puts "Version: #{RySafe::VERSION}"
    end

    def self.help_summary
      "Show version of RySafe"
    end
  end

  class Dispatcher
    attr_reader :key, :arguments

    def initialize(line)
      @key, *@arguments = Shellwords.split(line.strip)
    end

    def self.commands_hash
      registered_commands = Command::Base.register
      registered_commands.reduce({}) do |hash, command_class|
        key = command_class.new.command
        hash.merge(key => command_class)
      end
    end

    def commands_hash
      self.class.commands_hash
    end

    def self.commands
      commands_hash.keys
    end

    def command_class
      klass = commands_hash[@key]
      raise Error::NoCommand if klass.nil?
      klass
    end

    def command
      command_class.new(*@arguments)
    end

    def call
      command.call
    end
  end
end
