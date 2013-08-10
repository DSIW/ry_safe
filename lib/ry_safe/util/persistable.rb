# encoding: utf-8

module RySafe::Util::Persistable
  def save
    RySafe::Persistence::Tree.new.write YAML.dump(self)
  end

  def load
    YAML.load RySafe::Persistence::Tree.new.read
  end
end
