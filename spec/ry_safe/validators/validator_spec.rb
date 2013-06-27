# encoding: utf-8

require "spec_helper"

describe Validators::Validator do
  subject { Validators::Validator.new }

  it { should be_valid }
end
