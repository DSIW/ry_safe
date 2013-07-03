# encoding: utf-8

require "spec_helper"

describe Util::Presentable do
  class FakeModelPresenter < Presenter
    def name
      "FakeModelPresenter"
    end
  end

  class Safe::FakeModel
    include Util::Presentable

    attr_reader :name

    def initialize
      @name = "FakeModel"
    end
  end

  subject { model.presenter }
  let(:model) { Safe::FakeModel.new }

  it { should be_a FakeModelPresenter }
  its(:name) { should == "FakeModelPresenter" }
  its(:model) { should be model }
  its('model.name') { should == "FakeModel" }

  context "no presenter exists" do
    class NoPresenterModel
      include Util::Presentable

      attr_reader :name

      def initialize
        @name = "NoPresenterModel"
      end
    end

    subject { model.presenter }
    let(:model) { NoPresenterModel.new }

    it "should raise an exception" do
      expect { subject }.to raise_error Error::NoPresenterFound, "Presenter NoPresenterModelPresenter not found."
    end
  end
end
