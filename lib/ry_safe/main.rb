module RySafe
  class Main
    def initialize
      Persistence::Base.new.prepare_all
      Shell.new.prompt
    end
  end
end
