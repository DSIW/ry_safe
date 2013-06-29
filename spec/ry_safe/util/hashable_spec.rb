# encoding: utf-8

require "spec_helper"

describe Util::Hashable do
  class HashableObject
    include Util::Hashable

    protected

    def hash_data
      12345
    end
  end

  subject { HashableObject.new }

  describe "#sha1_hash" do
    its(:sha1_hash) { should == "8cb2237d0679ca88db6464eac60da96345513964" }
  end
end
