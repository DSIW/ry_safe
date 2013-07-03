require "spec_helper"

describe Presenter do
  subject { Presenter.new(model) }
  let(:model) do
    Class.new {
      def title
        "Title"
      end

      def to_s
        "to_string"
      end
    }.new
  end

  its(:model) { should == model }
  its(:to_s) { should == "to_string" }
  its(:title) { should == "Title" }
end
