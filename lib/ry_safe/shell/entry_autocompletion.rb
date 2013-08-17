# encoding: utf-8

module RySafe
  class EntryAutocompletion < NodeAutocompletion
    protected

    def current_children
      node && node.entries || []
    end
  end
end
