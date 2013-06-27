module RySafe::Safe
  class Entry < Node
    attr_accessor :website, :username, :comment, :title
    attr_reader :password, :password_confirmation, :tags

    def directory
      @parent
    end

    def directory=(dir)
      @parent = dir
    end

    def password=(password)
      @password = Password.new(password)
    end

    def password_confirmation=(password)
      @password_confirmation = Password.new(password)
    end

    def tags=(tags)
      @tags = tags.split(/,\s*|\s+/)
    end

    def valid?
      password == password_confirmation
    end
  end
end
