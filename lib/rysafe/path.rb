require './dir'
require './node'

module RySafe
  module Safe
    class Path

      attr_reader :parts

      def initialize *parts
        if parts.size == 1 && parts[0].is_a?(String)
          @parts = parts[0].split("/")
          @parts.last = @parts.last << "/" if parts[-1] == "/"
        else
          @parts = parts
        end
        evaluate
      end

      def evaluate
        @parts.flatten.compact
        set_root
        pwd = @root
        revaluate = false
        @parts = @parts.each_with_index.map do |part, index|
          if part.is_a? String 
            split = part.split "/"
            if split.length > 1
              split[-1] << "/" if part[-1] == "/"
              revaluate = true
              part = split
            else
              if part == ".."
                if index == 0
                  part = pwd.parent
                else
                  part = nil
                  @parts[index - 1] = nil
                end
              end
              if /^\.\.?$/ === part
                revaluate = true
                part = nil
              end
              if pwd.is_a? Dir
                part = pwd.get(part) || part
              end
            end
          end
          pwd = part
        end
        if revaluate
          evaluate
        end
      end

      def basename
        @parts.last
      end

      def pwd
        if @parts.last.is_a?(String) && @parts.last[-1] == "/" or @parts.last.is_a?(Dir)
          @parts.last
        elsif @parts.size > 1
          @parts[-2]
        else
          @root
        end
      end

      private 

      def set_root
        if @parts && @parts.first.is_a?(Dir)
          @root = @parts.first
          @parts = @parts[1..-1]
        else
          @root = Dir::ROOT
        end
      end

    end
  end
end
