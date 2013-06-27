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
      nil
    end

    def humand_readable_command
      command[0].upcase + command[1..-1]
    end
  end
end

