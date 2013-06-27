require 'securerandom'

module RySafe
  class PasswordGenerator
    DEFAULT_OPTIONS = { char_class: :default, exclude_similar: false }

    attr_reader :length, :options, :alphabet

    def initialize(length, options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @length = length
      @alphabet = alphabet_generator.new.add(@options[:char_class]).chars
    end

    def generate(count = 1)
      Array.new(count, "").map { random_password }
    end

    def password
      random_password
    end

    protected

    def random_password
      Password.new(random_string)
    end

    def random_string
      Array.new(@length, "").map { random_char }.join
    end

    def random_char
      @alphabet[random_alphabet_index]
    end

    def random_alphabet_index
      SecureRandom.random_number(@alphabet.size)
    end

    def alphabet_generator
      if @options[:exclude_similar]
        UnsimilarAlphabetGenerator
      else
        AlphabetGenerator
      end
    end
  end
end
