# encoding: utf-8

require "spec_helper"

describe Util::Persistable do
  class PersistanceStub
    include Util::Persistable

    attr_accessor :name, :children

    def encode_with coder
      coder['name'] = @name
      coder['children'] = @children
    end

    def init_with coder
      @name = coder['name']
      @children = coder['children']
    end
  end

  subject { PersistanceStub.new }
  let(:content) do
    <<-EOC
--- !ruby/object:PersistanceStub
name: ABC
children:
- 1
- 2
- 3
    EOC
  end

  describe "#serialize" do
    it "should serialize object" do
      subject.name = "ABC"
      subject.children = [1, 2, 3]
      subject.serialize.should == content
    end
  end

  describe "#deserialize" do
    it "should deserialize string to object" do
      new_obj = subject.deserialize(content)
      new_obj.name.should == "ABC"
      new_obj.children.should == [1, 2, 3]
    end
  end

  describe "#serialize and deserialize" do
    it "should get the old object" do
      serialized = subject.serialize
      object = PersistanceStub.new
      new_obj = object.deserialize(serialized)
      new_obj.name.should == subject.name
      new_obj.children.should == subject.children
    end
  end
end
