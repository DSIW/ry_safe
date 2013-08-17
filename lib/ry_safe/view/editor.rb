# encoding: utf-8

class RySafe::View::Editor < RySafe::View::Viewer
  def edit
    change_attribute(select_attribute, default: true)
  end

  def new
    attributes.each do |attribute|
      change_attribute(attribute, default: true)
    end
  end

  protected

  def attributes
    []
  end

  private

  def change_attribute(attribute, options = {})
    ask_for_method = "ask_for_#{attribute == :password ? attribute : :attribute}"
    answer = send(ask_for_method, attribute, options)

    @model.send("#{attribute}=", answer)
  end

  def ask_for_attribute(attribute, options = {})
    humanized_attribute = helper.capitalize(attribute).gsub('_', ' ')
    message = "#{humanized_attribute}:  "

    answer = HighLine.new.ask(message) do |q|
      q.default = @model.send(attribute) if options[:default]
      yield q if block_given?
    end
  end

  def ask_for_password(attribute, options = {})
    password = RySafe::View::Helper::PasswordQuestion.new.ask
    @model.send("#{attribute}=", password) unless password.nil?
  end

  def select_attribute
    chosen = HighLine.new.choose do |menu|
      menu.prompt = "Please choose an attribute:  "
      attributes.each { |attribute| menu.choice(helper.capitalize(attribute)) }
    end
    chosen && chosen.downcase.to_sym || nil
  end
end
