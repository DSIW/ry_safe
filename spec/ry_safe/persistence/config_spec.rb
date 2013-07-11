require "spec_helper"

describe Persistence::Config do
  subject { Persistence::Config.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/config.yml" }

  after do
    fake_home.restore
  end
end
