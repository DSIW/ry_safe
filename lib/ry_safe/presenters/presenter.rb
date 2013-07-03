module RySafe
  class Presenter

    attr_reader :model, :helper

    def initialize(model)
      @model = model
      @helper = Class.new { include Util::PresenterHelper }.new
    end

    def to_s
      model.to_s
    end

    def method_missing(meth, *args, &blk)
      if model.respond_to?(meth)
        model.send(meth, *args, &blk)
      else
        super meth, *args, &blk
      end
    end
  end
end
