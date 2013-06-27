# encoding: utf-8

require "singleton"

module RySafe::Safe
  class Tree < Dir
    include Singleton

    def initialize
      super ""
    end

    def self.root
      instance
    end
  end
end
