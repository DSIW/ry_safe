# encoding: utf-8

class RySafe::View::Helper::PasswordQuestion < RySafe::View::Helper::Question
  def ask(&block)
    @password = nil

    loop do
      @password = ask_password("Password", &block)
      @password_confirmation = ask_password("Password confirmation", &block)

      if Validators::PasswordValidator.new(@password, @password_confirmation).valid?
        break
      else
        puts "Passwords aren't identical."
      end
    end

    @password
  end

  private

  def ask_password(message, &block)
    HighLine.new.ask(message) do |q|
      q.echo = Password::HIDE_CHAR if Password.hidden?
      block.call(q) if block
    end
  end
end
