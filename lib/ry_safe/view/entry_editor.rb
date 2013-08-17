# encoding: utf-8

class RySafe::View::EntryEditor < RySafe::View::Editor
  def attributes
    [:username, :password, :website, :comment, :tags]
  end
end
