# encoding: utf-8

module RySafe::Safe
  class Node
    include Comparable
    include Util::Dates
    include Util::Hashable

    SEPARATOR = File::SEPARATOR

    attr_accessor :name, :parent

    def initialize name, parent = nil
      super # for dates
      raise ArgumentError if name.nil?
      @name = name
      @parent = parent
    end

    def self.from_path(path, options = {})
      NodeFinder.new(path, options[:in]).search
    end

    def self.create_from_path(path, options = {})
      raise ArgumentError if path == "/"

      elements = path.sub(/^\//, '').split(SEPARATOR)

      current = elements.last
      unless current.nil?
        top_node = elements.length == 1
        parent = if top_node
                   options[:in]
                 else
                   rest_path = elements[0..-2].join(SEPARATOR)
                   create_from_path(rest_path)
                 end
        Safe::Dir.new(current, parent)
      end
    end

    def root?
      @parent.nil?
    end

    def parent?
      !root?
    end

    def parents
      nodes = []
      if parent?
        nodes << parent
        nodes << parent.parents
      end
      nodes.flatten
    end

    def to_s
      path
    end

    def path
      nodes = []
      if parent?
        nodes << parent.path
      else
        nodes << nil # for first '/'
      end
      nodes << @name
      nodes.join(SEPARATOR)
    end

    def <=> other
      @name <=> other.name
    end

    def === pattern
      name === pattern
    end

    # required for Set in Safe::Dir
    def eql?(other)
      @name == other.name
    end

    # required for Set in Safe::Dir
    def hash
      @name.hash
    end

    protected

    def hash_data
      @name
    end
  end
end
