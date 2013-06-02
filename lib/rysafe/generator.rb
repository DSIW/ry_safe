require 'securerandom'

module RySafe
  module Generator
    def self.generate length=30, use_chars=CharacterClass::DEFAULT, options={}
      if use_chars.is_a? Hash
        chars = use_chars.keys.flatten
      else
        chars = use_chars
      end
      if options[:exclude_similar]
        chars -= %w[I l | O 0]
      end
      password = ""
      length.times do
        password << chars[SecureRandom::random_number(chars.size)]
      end
      if use_chars.is_a? Hash
        use_chars.each do |char_class, min_count|
          if password.count(char_class.join) < min_count
            return generate length, use_chars
          end
        end
      end
      return password
    end

    module CharacterClass
      NUM = ('0'..'9').to_a
      LOWER = ('a'..'z').to_a
      UPPER = ('A'..'Z').to_a
      SPACE = [' ']
      SPECIAL = ('!'..'/').to_a + (':'..'@').to_a + ('['..'`').to_a + ('{'..'~').to_a
      ALNUM = NUM + LOWER + UPPER
      DEFAULT = ALNUM + SPECIAL
      ALL = DEFAULT + SPACE
    end
  end
end
