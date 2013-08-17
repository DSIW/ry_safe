# encoding: utf-8

module RySafe
  class Path < Struct.new(:path)
    def dirname
      if root?
        "/"
      elsif absolute? && path.chars.select { |char| char == '/' }.size == 1
        "/"
      elsif empty? || splitted.size == 1 && !relative_directory?
        nil
      else
        (relative_directory? ? splitted : splitted[0..-2]).join('/')
      end
    end

    def filename
      if empty? || relative_directory?
        nil
      else
        splitted.last
      end
    end

    def empty?
      path == ""
    end

    def root?
      path == "/"
    end

    def relative_directory?
      splitted.last =~ /^\./
    end

    def to_s
      path
    end

    def to_node
      Safe::Node.create_from_path(path)
    end

    def to_existing_node_in(root = Safe::Tree.root)
      Safe::Node.from_path(path, in: root)
    end

    def absolute?
      path.start_with?("/")
    end

    def relative?
      !absolute?
    end

    private

    def splitted
      path.split('/')
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
      if path == "/"
        "/root"
      elsif path.start_with?("/root")
        path
      elsif path.start_with?("/")
        "/root#{path}"
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
