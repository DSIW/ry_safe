# encoding: utf-8

module RySafe
  class NodeAutocompletion
    def initialize(string)
      @string = string
    end

    def suggestions
      nodes
    end

    private

    def nodes
      escaped_children.grep(regex_string)
    end

    def current_children
      Safe::Tree.current.children
    end

    def escaped_children
      current_children.map { |item| item.name.gsub(" ", '\ ') }
    end

    def regex_string
      /^#{Regexp.escape(@string)}/
    end
  end
end
