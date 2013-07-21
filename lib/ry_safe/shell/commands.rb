# encoding: utf-8

require 'shellwords'

module RySafe::Commands
  class Base
    extend Util::Register
    include Util::CommandHelper

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

    def human_readable_command
      command[0].upcase + command[1..-1]
    end

    def self.help_summary
      nil
    end

    def self.command
      new.command
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
      puts current_path
    end

    def current_path
      Safe::Tree.current.presenter.path
    end

    def self.help_summary
      "Print the current directory path"
    end
  end

  class Clear < Base
    TERMINAL_HEIGHT = 40

    def command
      "clear"
    end

    def action
      puts "\n"*TERMINAL_HEIGHT
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

  #class Alias < Base
    #def command
      #"alias"
    #end

    #def action
      #Command::AliasSave.aliases << ""
    #end

    #def setting
      #arguments[0].split('=')
    #end

    #def new
      #setting[0]
    #end

    #def old
      #setting[1]
    #end
  #end

  #class Aliases < Hash
    #def <<(new, old)
      #self.add new, Dispatcher.new(old).command
    #end

    #def call(new)
      #self[new].call
    #end
  #end

  class Reload < Base
    def command
      "reload!"
    end

    def action
      files.each do |file|
        begin
          load file
        rescue Exception => e
        end
      end
      puts "Reloaded!"
    end

    def files
      Dir["#{File.dirname(__FILE__)}/../../**/*.rb"]
    end

    def self.help_summary
      "Reload RySafe for debugging"
    end
  end

  class Help < Base
    def command
      "help"
    end

    def action
      puts "All available commands are:\n\n#{commands}"
    end

    def commands
      Commands.all.map do |command|
        "#{command.command}: #{command.help_summary}"
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

  class PasswordGenerator < Base
    def command
      "gen_passwords"
    end

    def action
      puts passwords.map(&:inspect).join("\n")
    end

    def length
      arguments[0].to_i
    end

    def count
      arguments[1].to_i
    end

    def options
      arguments[2..-1]
        .map { |option| option.split('=') }
        .reduce({}) do |hash, (option, value)|
          hash.merge(option.to_sym => value)
        end
    end

    def self.help_summary
      "Generate new passwords"
    end

    def passwords
      RySafe::PasswordGenerator.new(length, options).generate(count)
    end
  end

  class Dispatcher
    attr_reader :key, :arguments

    def initialize(line)
      @key, *@arguments = Shellwords.split(line.strip)
    end

    def self.commands
      commands_hash.keys
    end

    def call
      command.call
    end

    def command
      command_class.new(*@arguments)
    end

    def command_class
      commands_hash.fetch(@key) { raise Error::NoCommand }
    end

    def self.commands_hash
      Commands.all.to_hash
    end

    def commands_hash
      self.class.commands_hash
    end
  end

  class Commands < Array
    def self.all
      new(all_registered + all_from_dsl)
    end

    def self.all_registered
      new(Base.register)
    end

    def self.all_from_dsl
      new(::RySafe::Commands::DSLCommands.commands)
    end

    def to_hash
      reduce({}) do |hash, command_class|
        hash.merge(command_class.command => command_class)
      end
    end
  end
end
