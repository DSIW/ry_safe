# encoding: utf-8

class RySafe::View::Viewer
  attr_reader :helper

  def initialize(model)
    @model = model
    @helper = Class.new { include Util::PresenterHelper }.new
  end
end
