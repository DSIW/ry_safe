# encoding: utf-8

module RySafe
  class Autocompletion
    ARGUMENT_APPEND_CHAR = ' '

    def initialize(line)
      @line = line
      Readline.completion_append_character = ARGUMENT_APPEND_CHAR
    end

    def call(string)
      autocompletion_class.new.call(string)
    end

    private

    def words
      Shellwords.split(@line)
    end

    def one_word?
      words.size == 1
    end

    def end_with?(char)
      @line.end_with?(char)
    end

    def autocompletion_class
      if one_word? && !end_with?(ARGUMENT_APPEND_CHAR)
        CommandAutocompletion
      else
        NodeAutocompletion
      end
    end
  end
end
