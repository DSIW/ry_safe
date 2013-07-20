# encoding: utf-8

module RySafe::Commands::DSL
  class CommandBuilder
    def initialize(name)
      @name = name.to_s
      @action = lambda { |*arguments| puts "Default" }
      @help_summary = "Default summary"
      @arguments = Hash.new { Argument.new }
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
      arguments.each_with_index do |arg, index|
        argument_to_save = @arguments[index]
        argument_to_save.value = arg
        @arguments[index] = argument_to_save
      end
      args = @arguments.map { |index, arg| arg.value }
      @action.call(*args)
    end

    def argument(index)
      if block_given?
        argument_to_save = @arguments[index]
        argument_to_save.manipulations << yield
        @arguments[index] = argument_to_save
      end
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
        apply_manipulations
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
