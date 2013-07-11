module RySafe::Persistence
  class History < File
    def location
      "#{super}/history.yml"
    end
  end
end
