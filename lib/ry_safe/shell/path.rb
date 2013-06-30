# encoding: utf-8

require "pathname"

module RySafe
  class Path < Struct.new(:path)
    def to_s
      path
    end

    def to_node
      Safe::Node.create_from_path(path)
    end

    def to_existing_node_in(root = Safe::Tree.current)
      Safe::Node.from_path(path, in: root)
    end

    def absolute?
      raise "Not implemented by Path."
    end

    def relative?
      !absolute?
    end
  end

  class RelativePath < Path
    attr_reader :pwd

    def initialize(path, pwd = Safe::Tree.current.path)
      super path
      @pwd = pwd
    end

    def to_absolute
      AbsolutePath.new(cleanpath)
    end

    def cleanpath
      if path.start_with?("/")
        path
      else
        absolute_path = File.join(@pwd, path)
        Pathname.new(absolute_path).cleanpath.to_s
      end
    end

    def absolute?
      false
    end
  end

  class AbsolutePath < Path
    def absolute?
      true
    end
  end
end
