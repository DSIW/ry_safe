# encoding: utf-8

module RySafe::Safe
  class Dir < Node
    include Util::Cloneable
    extend Forwardable

    attr_accessor :children

    def initialize(name, parent = nil)
      super
      @children = []
    end

    delegate [:size, :include?, :empty?, :clear] => :@children

    def children?
      !empty?
    end

    def <<(child)
      @children << child
      update_children_parents
    end

    def dirs
      @children.select { |child| child.is_a? self.class }
    end

    def find(query)
      results = []
      results << @children.select { |child| child === query }
      results << dirs.map { |dir| dir.find(query) }
      results.flatten
    end

    protected

    def update_children_parents
      @children.each do |child|
        child.parent = self
        child.update_children_parents if child.is_a? self.class
      end
    end
  end
end
