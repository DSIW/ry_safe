module RySafe
  class Shell
    def initialize
      @completions = Commands::Dispatcher.commands
      init_readline
    end

    def prompt
      RySafe::Persistence::History.new.load
      while line = Readline.readline(prompt_string, true) do
        begin
          eval_command(line)
          Readline::HISTORY.pop if line =~ /^\s*$/ || line =~ /^exit$/ || Readline::HISTORY.to_a[-2] == line
        rescue StandardError => e
          Readline::HISTORY.pop
          puts e.message
          puts e.backtrace.inspect
        ensure
          RySafe::Persistence::History.new.save
        end
      end
    end

    def prompt_string
      "#{Safe::Tree.current.presenter.path} > "
    end

    def eval_command line
      Commands::Dispatcher.new(line).call
    end

    protected

    def init_readline
      Readline.completion_append_character = " "

      Readline.completion_proc = lambda do |string|
        line = Readline.line_buffer
        if Shellwords.split(line).size == 1 && !line.end_with?(' ')
          @completions.grep(/^#{Regexp.escape(string)}/)
        else
          Safe::Tree.current.children.map{ |item| item.name.gsub(" ", '\ ') }.grep(/^#{Regexp.escape(string)}/)
        end
      end
    end
  end
end
