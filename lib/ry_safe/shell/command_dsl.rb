# encoding: utf-8

module RySafe::Commands::DSL
  class CommandBuilder
    def initialize(name)
      @name = name.to_s
      @action = lambda { |*arguments| puts "Default" }
      @help_summary = "Default summary"
      @arguments = Arguments.new
    end

    def name
      @name
    end

    def help_summary
      if block_given?
        @help_summary = yield
      else
        @help_summary
      end
    end

    def action(&action)
      if action
        @action = action
      else
        @action
      end
    end

    def call(*arguments)
      arguments.each_with_index { |arg, index| @arguments[index].value = arg }
      args = @arguments.map { |arg| arg.value }
      @action.call(*args)
    end

    def argument(index)
      @arguments[index].manipulations << yield if block_given?
    end

    #def to_command
      #Commands::Base.new()
    #end
  end

  class Arguments < Array
    def [](index)
      self[index] ||= Argument.new
    end
  end

  class Argument
    attr_accessor :manipulations
    attr_writer :value

    def initialize
      @manipulations = []
      @value = 0
    end

    def apply_manipulations
      manipulations.each { |manipulation| @value = manipulation.call(@value) }
    end

    def value
      @_value ||= begin
        apply_manipulations if @value
        @value
      end
    end

    def reset
      @_value = nil
    end
  end

  def commands
    @commands ||= Commands.new
  end

  class Commands < Array
    def [](cmd)
      select { |command| command.name == cmd.to_s }.first
    end
  end

  def command(name)
    cmd = CommandBuilder.new(name)
    yield(cmd) if block_given?
    commands << cmd
  end
end
