# encoding: utf-8

module RySafe::Util::Persistable
  def serialize
    YAML.dump(self)
  end

  def save
    RySafe::Persistence::Tree.new.write serialize
  end

  def deserialize(yaml)
    YAML.load(yaml)
  end

  def load
    deserialize(RySafe::Persistence::Tree.new.read)
  end
end
