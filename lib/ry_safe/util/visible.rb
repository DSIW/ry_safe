module RySafe::Util::Visible
  def hidden!
    @visible = false
  end

  def visible!
    @visible = true
  end

  def visible?
    !!@visible
  end

  def hidden?
    !visible?
  end
end
