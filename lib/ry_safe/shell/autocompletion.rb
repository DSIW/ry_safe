# encoding: utf-8

module RySafe
  class Autocompletion
    APPEND_CHAR = ' '

    def initialize(line, string)
      @line = line
      @string = string
    end

    def suggestions
      if one_word? && !end_with_append_char?
        filtered_commands
      else
        nodes
      end
    end

    private

    def words
      Shellwords.split(@line)
    end

    def one_word?
      words.size == 1
    end

    def end_with_append_char?
      @line.end_with?(APPEND_CHAR)
    end

    def regex_string
      /^#{Regexp.escape(@string)}/
    end

    def nodes
      escaped_children.grep(regex_string)
    end

    def current_children
      Safe::Tree.current.children
    end

    def escaped_children
      current_children.map { |item| item.name.gsub(" ", '\ ') }
    end

    def filtered_commands
      all_commands.grep(regex_string)
    end

    def all_commands
      Commands::Dispatcher.commands
    end
  end
end
