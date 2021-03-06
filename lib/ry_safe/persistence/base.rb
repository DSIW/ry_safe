module RySafe::Persistence
  class Base
    def self.register
      [
        Tree,
        History,
        Config
      ]
    end

    def register
      self.class.register
    end

    def location
      "#{ENV['HOME']}/.config/rysafe"
    end

    def prepare
      FileUtils.mkdir_p location unless Dir.exist? location
    end

    def prepare_all
      register.each { |klass| klass.new.prepare }
    end

    def write(content)
      ::File.open(location, 'w') { |file| file.write(content) }
    end

    def read
      ::File.read(location)
    end

    def save
      # should be overwritten by subclass
    end

    def load
      # should be overwritten by subclass
    end
  end
end
