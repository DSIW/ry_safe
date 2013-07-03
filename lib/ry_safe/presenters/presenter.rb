module RySafe
  class Presenter

    attr_reader :model

    def initialize(model)
      @model = model
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
