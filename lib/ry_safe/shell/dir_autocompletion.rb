# encoding: utf-8

module RySafe
  class DirAutocompletion < NodeAutocompletion
    PATH_APPEND_CHAR = '/'

    def initialize
      Readline.completion_append_character = PATH_APPEND_CHAR
    end

    protected

    def current_children
      node && node.dirs || []
    end
  end
end
