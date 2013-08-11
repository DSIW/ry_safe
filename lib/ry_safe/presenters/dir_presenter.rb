module RySafe
  class DirPresenter < NodePresenter
    def name
      "#{super}/"
    end

    def recursive_size
      model.recursive_size.to_s.rjust(3)
    end

    def children_size
      helper.pluralize(model.size, "item")
    end

    def dirs
      model.dirs.sort.map { |child| child.presenter.to_s }
    end

    def entries
      model.entries.sort.map { |child| child.presenter.to_s }
    end

    def children
      [dirs, entries, children_size].flatten.join("\n")
    end
  end
end
