# encoding: utf-8

module RySafe::Commands::DSL
  class CommandBuilder
    DEFAULT_ACTION = lambda {}
    DEFAULT_SUMMARY = "Default summary"

    attr_reader :name
    alias_method :command, :name

    def initialize(name)
      @name = name.to_s
      @action = DEFAULT_ACTION
      @help_summary = DEFAULT_SUMMARY
      @arguments = Hash.new { Argument.new }
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
      arguments.each_with_index { |arg, index| set_argument_value(index, arg) }
      args = @arguments.map { |index, arg| arg.value }
      @action.call(*args)
    end

    def argument(index, helper_function = nil)
      add_argument_manipulation(index) do
        lambda do |arg|
          if block_given?
            yield(arg)
          else
            helper_function && Util::CommandHelper.send(helper_function, arg) || arg
          end
        end
      end
    end

    private

    def set_argument(index)
      argument_to_save = @arguments[index]
      yield argument_to_save
      @arguments[index] = argument_to_save
    end

    def set_argument_value(index, value)
      set_argument(index) { |arg| arg.value = value }
    end

    def add_argument_manipulation(index)
      set_argument(index) { |arg| arg.manipulations << yield }
    end
  end

  class Argument
    attr_accessor :manipulations
    attr_writer :value

    def initialize
      @manipulations = []
      @value = nil
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

    def push(command)
      delete_if { |c| c.name == command.name }
      super
    end
    alias_method :<<, :push
  end

  def command(name)
    cmd = CommandBuilder.new(name)
    yield(cmd) if block_given?
    commands << cmd
  end
end
