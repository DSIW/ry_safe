# encoding: utf-8

module RySafe::Safe
  class Dir < Node
    attr_accessor :children

    def initialize(name, parent = nil)
      super
      @children = []
    end

    def children?
      !empty?
    end

    def empty?
      @children.empty?
    end

    def << child
      @children << child
      update_children_parents
    end

    def size
      @children.size
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

    def dup
      Marshal::load(Marshal.dump(self))
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
