# encoding: utf-8

module RySafe
  class PasswordPresenter < Presenter
    HIDE_CHAR = '*'

    def to_s
      if Password.visible?
        "'#{model.inspect}'"
      else
        HIDE_CHAR*model.inspect.length
      end
    end
  end
end
