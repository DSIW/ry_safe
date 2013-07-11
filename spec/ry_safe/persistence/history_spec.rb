require "spec_helper"

describe Persistence::History do
  subject { Persistence::History.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/history.yml" }

  after do
    fake_home.restore
  end
end
