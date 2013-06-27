# encoding: utf-8

class Commands < Array; end

module RySafe::Command
  class Base
    attr_reader :command, :arguments

    INPUT_SEPARATOR = /\s+/

    def initialize(string)
      splitted = string.strip.split(INPUT_SEPARATOR)
      @command = splitted.shift
      @arguments = splitted
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
  end

  class Touch < Base
    def initialize(*args)
      super "touch #{args.join(" ")}"
    end

    def command
      "touch"
    end

    def action
      Safe::Tree.root << Safe::Entry.new(arguments.first)
    end
  end
end
