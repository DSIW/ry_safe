require "spec_helper"

describe Persistence::Tree do
  subject { Persistence::Tree.new }

  before do
    fake_home.prepare
  end

  its(:location) { should == "#{ENV["HOME"]}/.config/rysafe/tree.yml" }

  after do
    fake_home.restore
  end
end
