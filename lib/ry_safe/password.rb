module RySafe
  class Password
    include Comparable
    include Util::Presentable

    class << self
      include Util::Visible
    end

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
      presenter.to_s
    end

    def inspect
      @password
    end
  end
end
