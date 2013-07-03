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

    def truncate(string, max_length, symbol = "...")
      if string.length > max_length
        string[0..(max_length - symbol.length - 1)] + symbol
      else
        string
      end
    end

    def align(left, right, max_length, separator = " ")
      left = left.to_s
      right = right.to_s
      separator_length = left.empty? || right.empty? ? 0 : separator.length

      max_length -= separator_length

      left_truncate_length = max_length - right.length
      aligned_left = truncate(left, left_truncate_length)

      rjust_length = max_length - left.length
      aligned_right = right.rjust(rjust_length)

      [aligned_left, aligned_right].reject(&:empty?).join(separator)
    end
  end
end
