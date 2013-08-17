# encoding: utf-8

class RySafe::View::Helper::Question < RySafe::View::Viewer
  attr_reader :helper

  def initialize(options = {})
    @options = options
    @default_value = @options.delete(:default_value)
    @helper = Class.new { include Util::PresenterHelper }.new
  end

  def ask(&block)
    nil
  end
end
