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

  before do
    fake_home.prepare
  end

  describe "#serialize" do
    it "should serialize object" do
      subject.name = "ABC"
      subject.children = [1, 2, 3]

      content = <<-EOC
--- !ruby/object:PersistanceStub
name: ABC
children:
- 1
- 2
- 3
      EOC

      subject.serialize.should == content
    end
  end

  describe "#save" do
    it "should serialize object and persist it" do
      subject.name = "ABC"
      subject.children = [1, 2, 3]

      content = <<-EOC
--- !ruby/object:PersistanceStub
name: ABC
children:
- 1
- 2
- 3
      EOC
      Persistence::Tree.any_instance.should_receive(:write).with(content)

      subject.save
    end
  end

  describe "#deserialize" do
    it "should deserialize string to object" do
      content = <<-EOC
--- !ruby/object:PersistanceStub
name: ABC
children:
- 1
- 2
- 3
      EOC

      new_obj = subject.deserialize(content)

      new_obj.name.should == "ABC"
      new_obj.children.should == [1, 2, 3]
    end
  end

  describe "#load" do
    it "should deserialize object and convert it into a normal ruby object" do
      subject.name = "ABC"
      subject.children = [1, 2, 3]

      content = <<-EOC
--- !ruby/object:PersistanceStub
name: ABC
children:
- 1
- 2
- 3
      EOC
      Persistence::Tree.any_instance.should_receive(:read).and_return(content)

      subject.load
    end
  end

  after do
    fake_home.restore
  end
end
