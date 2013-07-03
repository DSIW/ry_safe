# encoding: utf-8

require "spec_helper"

describe DirPresenter do
  subject { DirPresenter.new(dir) }
  let(:dir) { stub(methods) }
  let(:methods) do
    {
      name: "DIR",
      dirs: stub(sort: [
          stub(presenter: "presented_abc"),
          stub(presenter: "presented_zyk"),
      ]),
      entries: stub(sort: [
          stub(presenter: "presented_albaro"),
          stub(presenter: "presented_entri"),
      ]),
      recursive_size: 3,
      size: 4,
    }
  end

  its(:name) { should == "DIR/" }
  its(:recursive_size) { should == " 3" }
  its(:children_size) { should == "4 items" }
  its(:children) do
    string = <<-STRING
presented_abc
presented_zyk
presented_albaro
presented_entri
4 items
    STRING
    should == string.chomp
  end
end
