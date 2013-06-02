require './node'

module RySafe
  module Safe
    class Dir
      include Node

      def initialize name, parent=ROOT
        super name, parent
        @children = Array.new
      end

      def init_with coder
        super
        @children = coder['>']
      end

      def encode_with coder
        super
        coder['>'] = @children
      end

      def set_parents
        @children.each do |child|
          child.parent = self        
          if child.is_a? Dir
            child.set_parents
          end
        end        
      end

      def << child
        @children << child
      end

      def find query
        result = []
        result += @children.select {|child| child.match query}
        @children.select{|child| child.is_a? Safe::Dir}.each {|dir| result += dir.find(query)}
        result
      end

      def cp path, recursive=false
        unless recursive
          throw :DirectorySkipped, @name
        end
      end

      def dup
        copy = super.dup
        copy.children = []
        @children.each {|child| copy.children << child.dup}
        copy.touch
        copy
      end
                

      def rm recursive=false
        unless recursive
          throw :CannotRemoveDirectory
        end
        @children.each {|child| child.remove true}
        super
      end

      def rmdir
        if @children.any?
          throw :DirectoryNotEmpty
        end
        rm true
      end

      def get name
        find(name).first
      end

      def cd path
        if path.is_a? String
          path = Path.new self, path
        end
        unless path.basename.is_a? Dir
          throw :NoSuchDirectory
        end
        path.basename
      end

      alias :ls :children

      def dump_data
        {entries: @children}
      end

      def to_s
        @name
      end

      ROOT = self.new "/", nil
    end
  end
end
