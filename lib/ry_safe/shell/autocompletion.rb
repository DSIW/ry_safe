# encoding: utf-8

module RySafe
  class Autocompletion
    APPEND_CHAR = ' '

    def initialize(line, string)
      @line = line
      @string = string
    end

    def suggestions
      autocompletion_class.new(@string).suggestions
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

    def autocompletion_class
      if one_word? && !end_with_append_char?
        CommandAutocompletion
      else
        NodeAutocompletion
      end
    end
  end
end
