# encoding: utf-8

module RySafe::Commands
  class Base
    extend Util::Register
    include Util::CommandHelper

    attr_reader :name, :arguments

    def initialize(*args)
      @name = name || args.shift
      @arguments = args
    end

    def call
      action
    end

    def action
      raise "No action in Command::Base"
    end

    def self.help_summary
      nil
    end

    def self.name
      new.name
    end
  end

  #class Alias < Base
    #def action
      #Commands::Dispatcher.new(@arguments).call
    #end
  #end

  #class Aliases < Hash
    #def <<(new, old)
      #add(new, Alias.new(old).name)
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
        hash.merge(command_class.name => command_class)
      end
    end
  end
end
