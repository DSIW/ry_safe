require 'readline'
require 'shellwords'

module RySafe
  class Shell
    def initialize
      @completions = Command::Dispatcher.commands
      init_readline
    end

    def prompt
      while line = Readline.readline("#{Safe::Tree.current.presenter.path} > ", true) do
        begin
          eval_command(line)
        rescue StandardError => e
          puts e.message
          puts e.backtrace.inspect
        end
      end
    end

    def eval_command line
      Command::Dispatcher.new(line).call
    end

    protected

    def init_readline
      Readline.completion_append_character = " "

      Readline.completion_proc = lambda do |string|
        line = Readline.line_buffer
        if Shellwords.split(line).size == 1
          @completions.grep(/^#{Regexp.escape(string)}/)
        else
          Safe::Tree.current.children.map{ |item| item.name }.grep(/^#{Regexp.escape(string)}/)
        end
      end
    end
  end
end
