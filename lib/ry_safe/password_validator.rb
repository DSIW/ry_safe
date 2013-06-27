module RySafe
  class PasswordValidator < Validator
    def initialize(password, password_confirmation)
      @password = Password.new(password)
      @password_confirmation = Password.new(password_confirmation)
    end

    def valid?
      @password == @password_confirmation
    end
  end
end
