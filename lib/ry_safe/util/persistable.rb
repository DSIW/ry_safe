# encoding: utf-8

module RySafe::Util::Persistable
  def serialize
    YAML.dump(self)
  end

  def deserialize(yaml)
    YAML.load(yaml)
  end
end
