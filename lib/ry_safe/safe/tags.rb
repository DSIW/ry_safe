module RySafe::Safe
  class Tag < Struct.new(:name); end

  class Tags < Array
    def self.from_string(string)
      tags = string.split(/,\s*|\s+/).map { |tag| Tag.new(tag) }
      new(tags)
    end
  end
end
