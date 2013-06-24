# encoding: utf-8

require "spec_helper"

describe PasswordGenerator do

  subject { PasswordGenerator.new(length, options) }
  let(:length) { 8 }
  let(:options) { {} }

  its(:length) { should == 8 }
  its(:alphabet) { should == default_alphabet }

  it "should generate password with random chars" do
    subject.password.should be_a Password
  end

  it "should generate password with length" do
    subject.generate.first.length == 8
    subject.password.length == 8
  end

  it "should generate many passwords" do
    subject.generate(5).should have(5).passwords
  end

  describe "Private methods" do
    it "#random_alphabet_index" do
      indexes = (0..subject.alphabet.count)
      indexes.count.times { indexes.should include subject.send(:random_alphabet_index) }
    end

    it "#random_char" do
      alphabet = subject.alphabet
      chars = ''
      alphabet.count.times do
        char = subject.send(:random_char)
        chars << char
        alphabet.should include char
      end
      distributed_chars(chars).should be_true
    end
  end
end
