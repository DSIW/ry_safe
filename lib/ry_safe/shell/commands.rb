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

  class Dispatcher
    attr_reader :key, :arguments

    def initialize(line)
      @key, *@arguments = Shellwords.split(line.strip)
    end

    def self.commands
      commands_hash.keys
    end

    def call
      command.call(*@arguments)
    end

    def command
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
