module RySafe
  class AlphabetGenerator
    #SPECIAL_CHARS = %w(_ ! . , -)
    SPECIAL_CHARS = ('!'..'/').to_a + (':'..'@').to_a + ('['..'`').to_a + ('{'..'~').to_a
    SPACE         = [' ']
    NUMBERS       = ('0'..'9').to_a
    BIG_CHARS     = ('A'..'Z').to_a
    LITTLE_CHARS  = ('a'..'z').to_a

    CHARS = LITTLE_CHARS + BIG_CHARS
    ALNUM = CHARS + NUMBERS
    DEFAULT = ALNUM + SPECIAL_CHARS
    ALL = CHARS + NUMBERS + SPACE + SPECIAL_CHARS

    attr_reader :chars

    def initialize
      @chars = []
    end

    def add(*arg)
      arg.each { |arg| @chars << convert_argument(arg) }
      clean
      self
    end
    alias_method :<<, :add

    def to_s
      chars
    end

    protected

    def clean
      @chars.flatten!
      @chars.uniq!
    end

    def convert_argument(arg)
      case arg
      when String then self.class.const_get(arg.upcase.to_sym)
      when Symbol then self.class.const_get(arg.upcase)
      else arg
      end
    end
  end

  class UnsimilarAlphabetGenerator < AlphabetGenerator
    def chars
      super - %w[I l | O 0]
    end
  end
end
