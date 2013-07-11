module RySafe::Persistence
  class Tree < File
    def location
      "#{super}/tree.yml"
    end
  end
end
