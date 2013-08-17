module RySafe
  class Shell
    def initialize
      Readline.completion_proc = lambda { |string | Autocompletion.new(Readline.line_buffer).call(string) }
    end

    def prompt
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
  end
end
