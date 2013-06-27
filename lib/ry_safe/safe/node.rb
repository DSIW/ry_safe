# encoding: utf-8

module RySafe::Safe
  class Node
    include Comparable
    include Util::Dates
    include Util::Hashable

    SEPARATOR = File::SEPARATOR

    attr_accessor :name, :parent

    def initialize name, parent = nil
      raise ArgumentError if name.nil?
      @name = name
      @parent = parent
    end

    def self.from_path(path)
      raise ArgumentError if path == "/"

      elements = path.sub(/^\//, '').split(SEPARATOR)

      current = elements.last
      unless current.nil?
        empty = elements.empty?
        parent = empty ? nil : from_path(elements[0..-2].join(SEPARATOR))
        new(current, parent)
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

    protected

    def hash_data
      @name
    end
  end
end
