module RySafe::Persistence
  class File < Base
    def prepare
      Base.new.prepare
      FileUtils.touch location
    end
  end
end
