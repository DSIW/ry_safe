module RySafe::Util::Safeable
  def initialize(*args, &block)
    unsafe!
  end

  def unsafe!
    @safe = false
  end

  def safe!
    @safe = true
  end

  def safe?
    @safe
  end

  def unsafe?
    !safe?
  end
end
