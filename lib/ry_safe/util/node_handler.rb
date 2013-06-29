# encoding: utf-8

module RySafe::Util::NodeHandler
  class << self
    def copy(source, destination)
      raise Error::SourceNotNode unless source.kind_of? Safe::Node
      raise Error::NotCopyable if source.root?
      raise Error::DestinationNotNode unless destination.is_a? Safe::Dir
      raise Error::SameSourceAndDestination if source == destination

      cloned_source = source.dup
      destination << cloned_source
      cloned_source
    end

    # TODO: Remove complete (with children) instead of only removing link to parent
    def remove(node)
      raise Error::NotNode unless node.is_a? Safe::Node
      raise Error::NotRemovable if node.root?

      if node.parent.is_a? Safe::Dir
        node.parent.delete(node) { raise "Node #{node} does not exist." }
      end

      node.parent = nil
      node.freeze
      node
    end

    def move(source, destination)
      raise Error::SourceNotNode unless source.kind_of? Safe::Node
      raise Error::DestinationNotNode unless destination.is_a? Safe::Dir
      raise Error::NotMovable if source.root?
      raise Error::SameSourceAndDestination if source == destination

      source.parent.delete(source)
      destination << source
    end
  end
end
