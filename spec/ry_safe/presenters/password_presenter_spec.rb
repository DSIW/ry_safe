# encoding: utf-8

require "spec_helper"

describe PasswordPresenter do
  subject { PasswordPresenter.new(password) }
  let(:password) { Password.new("_123456 ") }

  its(:to_s) { should == "********" }

  context "with visible passwords" do
    before { Password.visible! }

    its(:to_s) { should == "'_123456 '" }
  end
end
