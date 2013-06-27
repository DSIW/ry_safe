module RySafe::Safe
  class Entry < Node
    attr_accessor :website, :username, :comment, :title
    attr_reader :password, :password_confirmation, :tags

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
      PasswordValidator.new(@password, @password_confirmation).valid?
    end
  end
end
