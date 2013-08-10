module RySafe
  class Password
    include Comparable

    class << self
      include Util::Visible
    end

    HIDE_CHAR = '*'

    attr_reader :password

    def initialize(password)
      @password = password
    end

    def <=>(other)
      other.password <=> @password
    end

    def length
      @password.length
    end

    def to_s
      if self.class.visible?
        @password
      else
        HIDE_CHAR*@password.length
      end
    end

    def inspect
      @password
    end
  end
end
