# encoding: utf-8

require "singleton"

module RySafe::Safe
  class Tree < Dir
    include Singleton

    def initialize
      super "root"
    end

    def current=(dir)
      raise Error::NotInTree unless dir.parents.include? self
      @current = dir
    end

    def current
      #current or root
      @current || self
    end

    def reset_current
      @current = nil
    end

    def clear
      super
      reset_current
    end

    class << self
      extend Forwardable

      def root
        instance
      end

      delegate [:current=, :current, :clear, :reset_current] => :instance
    end
  end
end
