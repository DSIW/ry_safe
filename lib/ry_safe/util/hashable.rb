# encoding: utf-8

require 'digest'

module RySafe::Util::Hashable
  def sha1_hash
    Digest::SHA1.hexdigest hash_data.to_s
  end

  protected

  def hash_data
    # should be overwritten after include
  end
end
