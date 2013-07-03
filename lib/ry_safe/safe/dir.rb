# encoding: utf-8

require "set"

module RySafe::Safe
  class Dir < Node
    include Util::Cloneable
    extend Forwardable

    def initialize(name, parent = nil)
      super
      @children = Set.new
    end

    delegate [:clear, :delete] => :@children
    delegate [:size, :include?, :empty?] => :children

    def children=(children)
      @children = children.to_set
    end

    def children
      @children.to_a
    end

    def recursive_size
      sum = 0
      sum += size
      dirs.each { |dir| sum += dir.recursive_size }
      sum
    end

    def children?
      !empty?
    end

    def <<(child)
      not_added = @children.add?(child).nil?
      raise Error::AlreadyExist if not_added
      child.parent = self
    end

    def siblings
      if parent?
        siblings = parent.children
        siblings.delete(self)
        siblings
      else
        []
      end
    end

    def dirs
      @children.select { |child| child.is_a? self.class }
    end

    def entries
      @children.select { |child| child.is_a? Safe::Entry }
    end

    def find(query)
      results = []
      results << @children.select { |child| child === query }
      results << dirs.map { |dir| dir.find(query) }
      results.flatten
    end

    def [](node_name)
      children.each { |node| return node if node.name == node_name }
      nil
    end
  end
end
