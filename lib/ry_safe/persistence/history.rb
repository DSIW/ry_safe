module RySafe::Persistence
  class History < File
    def prepare
      super
      load
    end

    def location
      "#{super}/history.yml"
    end

    def save
      write(YAML.dump(Readline::HISTORY.to_a))
    end

    def load
      history_items = YAML.load(read)
      history_items.each { |item| Readline::HISTORY.push(item) }
    end
  end
end
