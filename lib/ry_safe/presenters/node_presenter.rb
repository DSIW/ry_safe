module RySafe
  class NodePresenter < Presenter
    def path
      helper.remove_root(model.path)
    end

    def dates
      modified_at
    end

    def created_at
      helper.format_time(model.created_at)
    end

    def modified_at
      helper.format_time(model.modified_at)
    end

    def destroyed_at
      date = model.destroyed_at
      date.nil? ? "--" : helper.format_time(date)
    end

    def recursive_size
      "".rjust(3)
    end

    def to_s
      [dates, recursive_size, name].join(' ')
    end
  end
end
