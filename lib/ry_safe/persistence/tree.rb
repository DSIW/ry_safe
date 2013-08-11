module RySafe::Persistence
  class Tree < File
    def location
      "#{super}/tree.yml"
    end

    def save
      write(Safe::Tree.root.serialize)
    end

    def load
      new_root_dir = Safe::RootDir.new.deserialize(read)
      Safe::Tree.root.from_other(new_root_dir)
    end
  end
end
