module RySafe::Util::Cloneable
  def dup
    Marshal.load(Marshal.dump(self))
  end
end
