# encoding: utf-8

require "singleton"

module RySafe::Safe
  class Tree < RootDir
    include Singleton

    def to_root_dir
      Safe::RootDir.new.from_other(self)
    end

    def serialize
      to_root_dir.serialize
    end

    def from_other(other)
      @name = other.name
      @current = other.current
      @children = other.children
      self
    end

    class << self
      extend Forwardable

      def root
        instance
      end

      delegate [:current=, :current, :clear, :reset_current, :go_up] => :instance
    end
  end
end
