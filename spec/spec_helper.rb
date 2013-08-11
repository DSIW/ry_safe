require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'ry_safe'
require 'ostruct'
require 'fake_home'
require 'timecop'

RSpec.configure do |config|
  include RySafe

  config.before do
    time = Time.local(2013, 1, 1, 12, 13, 14)
    Timecop.freeze(time)
  end

  config.after do
    Timecop.return
  end

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

  def fake_home
    @@fake_home ||= FakeHome::Home.new(prefix: "rysafe", suffix: "home")
  end
end
