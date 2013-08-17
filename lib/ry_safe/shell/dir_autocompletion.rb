# encoding: utf-8

module RySafe
  class DirAutocompletion < NodeAutocompletion
    protected

    def current_children
      node && node.dirs || []
    end
  end
end
