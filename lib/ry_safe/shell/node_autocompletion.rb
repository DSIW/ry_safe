# encoding: utf-8

module RySafe
  class NodeAutocompletion
    def initialize
      Readline.completion_append_character = Autocompletion::ARGUMENT_APPEND_CHAR
    end

    def call(string)
      @string = string
      nodes
    end

    protected

    def nodes
      Filters.new(current_children).filter(path.filename).names.escape.join(dirname == "/" ? "" : dirname)
    end

    def current_children
      node && node.children || []
    end

    def node
      Util::CommandHelper.relative_path_to_existing_node(dirname || ".")
    end

    def dirname
      path.dirname
    end

    def path
       Path.new(@string)
    end

    class Filters < Array
      def filter(word)
        word && this(select { |child| child.name =~ /^#{word}/i }) || self
      end

      def names
        this map { |child| child.name }
      end

      def escape
        this map { |name| name.gsub(' ', '\ ') }
      end

      def join(dirname)
        this map { |child| [dirname, child].compact.join('/') }
      end

      private

      def this(collection)
        self.class.new(collection)
      end
    end
  end
end
