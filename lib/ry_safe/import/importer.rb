# encoding: utf-8

class RySafe::Import::Importer
  def initialize(file)
    @file = file
  end

  def file_content
    @file_content ||= File.read(@file)
  end

  def import
    # should be implemented by subclass
  end
end
