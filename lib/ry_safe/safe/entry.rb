module RySafe::Safe
  class Entry < Node
    attr_accessor :website, :username, :comment
    attr_reader :password, :password_confirmation, :tags

    def initialize(name, parent = nil)
      super
      @tags = Tags.new
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

    def encode_with coder
      super
      coder['username'] = @username
      coder['password'] = @password.inspect
      coder['website'] = @website
      coder['comment'] = @comment
      coder['tags'] = @tags
    end

    def init_with coder
      super
      @username = coder['username']
      @website = coder['website']
      @comment = coder['comment']
      @password = Password.new(coder['password'])
      @tags = Tags.new(coder['tags'])
    end
  end
end
