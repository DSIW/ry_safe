module RySafe::Persistence
  class File < Base
    def prepare
      super
      FileUtils.touch location
    end
  end
end
