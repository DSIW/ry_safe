require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'ry_safe'
require 'ostruct'

RSpec.configure do |config|
  include RySafe

  # Returns the full path to the +name+ fixture file.
  def fixture(name)
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
  end

  def distributed_chars(word)
    chars = word.split('')
    return false if chars.uniq.count <= 1

    stat = Hash.new(0)
    chars.each { |char| stat[char] += 1 }
    stat.values.max < subject.length * 3/4
  end

  def default_alphabet
    AlphabetGenerator.new.add(:default).chars
  end
end
