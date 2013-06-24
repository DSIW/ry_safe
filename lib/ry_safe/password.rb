module RySafe
  class Password
    include Comparable
    include Util::Safeable

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
      if safe?
        @password
      else
        '*'*@password.length
      end
    end
  end
end
