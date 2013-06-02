require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'ry_safe'

RSpec.configure do |config|
  include RySafe

  # Returns the full path to the +name+ fixture file.
  def fixture(name)
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
  end
end
