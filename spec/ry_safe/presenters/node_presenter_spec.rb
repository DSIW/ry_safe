# encoding: utf-8

require "spec_helper"

describe NodePresenter do
  subject { NodePresenter.new(node) }
  let(:node) { OpenStruct.new(methods) }
  let(:methods) do
    {
      name: "NAME",
      to_s: "TO_S",
      created_at: Time.new(2013,01,01,12,00,00),
      modified_at: Time.new(2013,01,02,12,00,00),
      destroyed_at: Time.new(2013,01,03,12,00,00),
      path: "/root/path/to/name",
      recursive_size: 2,
    }
  end

  its(:path) { should == "/path/to/name" }

  context "message" do
    let(:methods) { {path: "/root"} }
    its(:path) { should == "/" }
  end

  its(:dates) { should == "2013-01-02 12:00:00" }
  its(:created_at) { should == "2013-01-01 12:00:00" }
  its(:modified_at) { should == "2013-01-02 12:00:00" }

  its(:destroyed_at) { should == "2013-01-03 12:00:00" }

  context "without destroyed_at" do
    let(:methods) { {destroyed_at: nil} }
    its(:destroyed_at) { should == "--" }
  end

  its(:recursive_size) { should == "  " }

  its(:to_s) { should == "2013-01-02 12:00:00    NAME" }
end
