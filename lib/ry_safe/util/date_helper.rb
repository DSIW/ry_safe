# encoding: utf-8

module RySafe::Util::DateHelper
  module_function

  DATE_FORMAT = "%FT%T"

  def parse_time(string)
    string && DateTime.iso8601(string)
  end

  def format_time(time)
    time && time.strftime(DATE_FORMAT)
  end
end
