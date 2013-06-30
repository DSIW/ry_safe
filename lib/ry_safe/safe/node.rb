# encoding: utf-8

module RySafe::Safe
  class NodeFinder
    attr_reader :tree, :path

    def initialize(path, tree)
      @path = path
      @tree = tree
    end

    def search
      return tree if path == "/root"
      elements = path.sub(/^\/root\//, '').split(Node::SEPARATOR)

      current_name = elements.first
      unless current_name.nil? # root
        last_element = elements.length == 1
        if last_element && current_name == tree.name
          return tree
        else
          tree.children.each do |child|
            if current_name == child.name
              if last_element
                return child
              else
                rest_path = elements[1..-1].join(Node::SEPARATOR)
                return NodeFinder.new(rest_path, child).search
              end
            end
          end
          nil
        end
      end
    end
  end

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
