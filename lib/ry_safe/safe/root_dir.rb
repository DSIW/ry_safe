module RySafe::Safe
  class RootDir < Dir
    def initialize
      super "root"
    end

    def current=(dir)
      raise Error::NotInTree if self != dir && !dir.parents.include?(self)
      @current = dir
    end

    def current
      #current or root
      @current || self
    end

    def reset_current
      @current = nil
    end

    def go_up
      @current = @current.parent if @current.parent?
    end

    def clear
      super
      reset_current
    end

    def from_other(other)
      @name = other.name
      @current = other.current
      @children = other.children
      self
    end

    def encode_with coder
      super
      coder["current"] = @current && @current.path || "/root"
    end

    def init_with coder
      super
      @current = Node.from_path(coder['current'], in: self)
    end
  end
end
