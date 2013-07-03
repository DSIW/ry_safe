module RySafe::Safe
  class Entry < Node
    attr_accessor :website, :username, :comment
    attr_reader :password, :password_confirmation, :tags

    def initialize(name, parent = nil)
      raise ArgumentError, "name can't be blank." if name.nil? || name.to_s.strip.empty?
      super

      @tags = []
    end

    def directory
      @parent
    end

    def directory=(dir)
      parent = dir
      dir << self
    end

    def password=(password)
      @password = Password.new(password)
    end

    def password_confirmation=(password)
      @password_confirmation = Password.new(password)
    end

    def tags=(string)
      @tags = Tags.from_string(string)
    end

    def valid?
      Validators::PasswordValidator.new(@password, @password_confirmation).valid?
    end
  end
end
