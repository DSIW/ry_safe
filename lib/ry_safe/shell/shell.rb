module RySafe
  class Shell
    def initialize
      Readline.completion_append_character = Autocompletion::APPEND_CHAR

      Readline.completion_proc = lambda do |string|
        line = Readline.line_buffer
        Autocompletion.new(line, string).suggestions
      end
    end

    def prompt
      while line = Readline.readline(prompt_string, true) do
        begin
          eval_command(line)
          Readline::HISTORY.pop if line =~ /^\s*$/ || line =~ /^exit$/ || Readline::HISTORY.to_a[-2] == line
        rescue StandardError => e
          Readline::HISTORY.pop
          puts e.message
        ensure
          RySafe::Persistence::History.new.save
          #puts e.backtrace.inspect
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
