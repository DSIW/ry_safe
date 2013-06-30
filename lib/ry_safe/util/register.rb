# encoding: utf-8

require "set"

module RySafe::Util
  module Register
    def register
      (@register ||= SortedSet.new).to_a
    end

    def inherited(child_class)
      register << child_class
    end
  end
end
