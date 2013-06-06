# encoding: utf-8

require "spec_helper"

describe Util::Dates do
  class DatesObject
    include Util::Dates

    attr_reader :name

    def initialize(name)
      super
      @name = name
    end

    def update
      @updated = true
      touch
    end

    def updated?
      !!@updated
    end

    def destroy
      super
      @destroyed = true
    end

    def destroyed?
      !!@destroyed
    end
  end

  let(:stopped_time) { Time.new(2013, 01, 01, 00, 00) }
  before { Time.stub(now: Time.new(2013, 01, 01, 00, 00)) }

  subject { DatesObject.new(name) }
  let(:name) { "Name" }

  its(:name) { should == "Name" }

  its(:created_at) { should == stopped_time }
  its(:modified_at) { should == stopped_time }
  its(:destroyed_at) { should be_nil }

  describe "#touch" do
    let(:stopped_time) { Time.new(2013, 01, 02, 00, 00) }
    before { Time.stub(now: Time.new(2013, 01, 02, 00, 00)) }

    before { subject.update }

    its(:touch) { should == stopped_time }
    its(:update) { should == stopped_time }
    its(:modified_at) { should == stopped_time }
  end

  describe "#destroy" do
    let(:stopped_time) { Time.new(2013, 01, 03, 00, 00) }
    let(:destroy_time) { Time.new(2013, 01, 03, 00, 00) }
    before { Time.stub(now: Time.new(2013, 01, 03, 00, 00)) }

    before { subject.destroy }

    its(:touch) { should == stopped_time }
    its(:update) { should == stopped_time }
    its(:modified_at) { should == stopped_time }

    its(:destroyed_at) { should == destroy_time }
  end
end
