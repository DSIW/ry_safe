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
    alias_method :command, :name

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
      if block_given?
        convert_function = lambda { |arg| yield(arg) }
      else
        convert_function = lambda { |arg| helper_function && Util::CommandHelper.send(helper_function, arg) || arg }
      end
      add_argument_manipulation(index) { convert_function }
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
