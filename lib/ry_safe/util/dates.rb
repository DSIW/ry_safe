# encoding: utf-8

module RySafe::Util::Dates
  attr_reader :created_at, :modified_at, :destroyed_at

  def initialize(*args, &block)
    @created_at = now
    touch
  end

  def touch
    @modified_at = now
  end

  def destroy
    @destroyed_at = now
  end

  protected

  def now
    Time.now
  end
end
