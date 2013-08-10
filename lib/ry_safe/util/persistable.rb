# encoding: utf-8

module RySafe::Util::Persistable
  def serialize
    YAML.dump(self)
  end

  def save
    RySafe::Persistence::Tree.new.write serialize
  end

  def load
    YAML.load RySafe::Persistence::Tree.new.read
  end
end
