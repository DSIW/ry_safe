# encoding: utf-8

module RySafe::Util
  module PresenterHelper
    COLORS = {
      website: :green,
      username: :green,
      dirname: :cyan,
      path: :yellow,
      password: lambda { |*_| Password.hidden? ? :green : :red },
      boolean: lambda { |*string| string == "true" ? :green : :red },
    }

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

    def format_time(time)
      time && time.strftime("%F %H:%M:%S")
    end

    def remove_root(string)
      string.sub("/root", "/").sub("//", "/")
    end

    def capitalize(string)
      string[0].upcase + string[1..-1]
    end

    def present?(obj)
      obj && obj.is_a?(String) ? !obj.empty? : obj
    end

    def colorize(string, color = nil)
      string = string.to_s

      color = COLORS[color]
      color = color.respond_to?(:call) ? color.call(string) : color

      string.colorize(color)
    end
  end
end
