# encoding: utf-8

module RySafe::Safe
  class NodeFinder
    ROOT_PATH = "/root"

    attr_reader :tree, :path

    def initialize(path, tree)
      raise ArgumentError, "Tree has to be set" unless tree.is_a? Safe::Node

      @path = path
      @tree = tree
    end

    def search
      return tree if path == ROOT_PATH

      if root?
        found_top? ? tree : search_in_children
      else
        search_in_children
      end
    end

    protected

    def root?
      current_name.nil?
    end

    def found_top?
      last_element? && same_names_with?(tree)
    end

    def same_names_with?(node)
      current_name == node.name
    end

    def current_name
      elements.first
    end

    def elements
      path.sub(/^\/root\//, '').split(Node::SEPARATOR)
    end

    def last_element?
      elements.length == 1
    end

    def search_in_children
      each_child do |child|
        if same_names_with?(child)
          return last_element? ? child : search_in(child)
        end
      end
      nil
    end

    def each_child
      tree.children.each { |child| yield child }
    end

    def search_in(child)
      NodeFinder.new(rest_path, child).search
    end

    def rest_path
      elements[1..-1].join(Node::SEPARATOR)
    end
  end
end
