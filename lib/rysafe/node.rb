require './path'
require 'digest'

module RubySafe
  module Safe
    module Node
      include Comparable

      attr_reader :children, :parent
      attr_accessor :name

      def initialize name, parent
        @parent = parent
        @name = name
        unless @parent.nil?
          if @parent.get name
            throw :NodeExistsError 
          end
          @parent << self
        end
        touch
      end

      def encode_with coder
        coder['name'] = @name
        coder['modified'] = @modified
        coder['hash'] = @hash
      end

      def init_with coder
        @name = coder['name']
        @modified = coder['modified']
        @hash = coder['hash']
        touch
      end

      def <=> other
        @name <=> other.name        
      end

      def touch
        new_hash = hash
        if @hash != new_hash
          @modified = Time.now.to_s
          @hash = new_hash
        end
      end

      def hash
        Digest::SHA1.hexdigest hash_data
      end

      def mv path
        if path.is_a? String
          path = Path.new @parent, path
        end
        if path.basename.is_a? String
          if path.pwd.is_a? String
            throw :PathDoesNotExist
          end
          if path.pwd != path.basename
            @name = path.basename
          end
          path.pwd << self
          @parent = path.pwd
        end
        touch
      end

      def cp path, recursive=false
        if path.is_a? String
          path = Path.new path
        end
        if path.pwd.is_a? String
          throw :PathDoesNotExist
        end
        copy = self.dup
        if path.pwd != path.basename
          copy.name = path.basename
        end
        path.pwd << copy
        copy.parent = path.pwd
      end 

      def rm recursive=false
        if @parent
          @parent.children.delete(self)
        else
          throw :CannotRemoveRoot
        end
      end

      def match query
        query === @name
      end

      def to_s
        @name          
      end

      private

      def hash_data
        @name
      end

    end
  end
end
