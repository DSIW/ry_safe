# encoding: utf-8

require "spec_helper"

describe Validators::PasswordValidator do
  subject { Validators::PasswordValidator.new(password, password_confirmation) }
  let(:password) { "123456" }
  let(:password_confirmation) { "123456" }

  it { should be_valid }

  context "with different passwords" do
    let(:password_confirmation) { "123" }
    it { should_not be_valid }
  end
end
