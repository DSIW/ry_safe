# encoding: utf-8

class Commands < Array; end

module RySafe::Command
  class Base
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
      Safe::Tree.current = relative_path_to_existing_node(arguments.first)
    end
  end

  class Movement < Base
    def source
      relative_path_to_existing_node(arguments[0])
    end

    def destination
      relative_path_to_existing_node(arguments[1])
    end
  end

  class Copy < Movement
    def command
      "cp"
    end

    def action
      Util::NodeHandler.copy(source, destination)
    end
  end

  class Move < Movement
    def command
      "mv"
    end

    def action
      Util::NodeHandler.move(source, destination)
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
end
