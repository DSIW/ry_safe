# encoding: utf-8

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

    protected

    def absolute_path(relative_path)
      RelativePath.new(relative_path).to_absolute
    end

    def relative_path_to_node(relative_path)
      absolute_path(relative_path).to_node
    end

    def relative_path_to_existing_node(relative_path, root = Safe::Tree.root)
      absolute_path(relative_path).to_existing_node_in(root)
    end
  end

  class Touch < Base
    def command
      "touch"
    end

    def action
      Safe::Tree.root << Safe::Entry.new(arguments.first)
    end
  end

  class MkDir < Base
    def command
      "mkdir"
    end

    def action
      Safe::Tree.root << Safe::Dir.new(arguments.first)
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
  end

  class Move < Base
    include Movement

    def command
      "mv"
    end

    def action
      Util::NodeHandler.move(source, destination)
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
  end

  class Dispatcher
    INPUT_SEPARATOR = /\s+/

    attr_reader :key, :arguments

    def initialize(line)
      @key, *@arguments = line.strip.split(INPUT_SEPARATOR)
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
