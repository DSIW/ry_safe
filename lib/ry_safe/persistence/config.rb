module RySafe::Persistence
  class Config < File
    def location
      "#{super}/config.yml"
    end
  end
end
