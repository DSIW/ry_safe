# encoding: utf-8

module RySafe
  class CommandAutocompletion
    def initialize(string)
      @string = string
    end

    def suggestions
      filtered_commands
    end

    private

    def filtered_commands
      all_commands.grep(regex_string)
    end

    def all_commands
      Commands::Dispatcher.commands
    end

    def regex_string
      /^#{Regexp.escape(@string)}/
    end
  end
end
