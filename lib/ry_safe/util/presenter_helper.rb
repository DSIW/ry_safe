# encoding: utf-8

#require 'colorize'

module RySafe::Util
  module PresenterHelper
    def colorize(string, color, condition)
      string = string.to_s
      string = string.colorize(color) if condition
      string
    end

    def pluralize(count, singular, plural = nil)
      plural ||= "#{singular}s"
      name = count.abs == 1 ? singular : plural
      "#{count} #{name}"
    end
  end
end
