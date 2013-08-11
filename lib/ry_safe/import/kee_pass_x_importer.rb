# encoding: utf-8

require "nori"

module RySafe::Import
  class KeePassXImporter < Importer
    def import
      root.each { |child| GroupNode.new(child, nil).import }
    end

    private

    def root
      file_to_hash[:database][:group]
    end

    def file_to_hash
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      parser.parse(file_content)
    end
  end

  GroupNode = Struct.new(:hash, :parent) do
    def import
      convert
      import_groups(to_array(hash[:group])) if hash[:group]
      import_entries(to_array(hash[:entry])) if hash[:entry]
    end

    def import_entries(entries)
      entries.each do |entry|
        node = EntryNode.new(entry, convert)
        node.to_entry.convert
      end
    end

    def import_groups(groups)
      groups.each do |group|
        node = GroupNode.new(group, convert)
        node.import
      end
    end

    def to_group
      Group.new(hash[:title], parent)
    end

    private

    def convert
      @converted ||= to_group.convert
    end

    def to_array(array_or_hash)
      array_or_hash.is_a?(Array) ? array_or_hash : [array_or_hash]
    end
  end

  EntryNode = Struct.new(:hash, :parent) do
    def to_entry
      Entry.new(hash[:title], hash[:username], hash[:password], hash[:url], hash[:comment], hash[:creation], hash[:lastaccess], hash[:lastmod], hash[:expire], parent)
    end
  end

  module ConvertionHelper
    module_function

    def try_convertion(title, parent, number = 1, &block)
      title = (title.nil? || title.to_s.strip.empty?) ? 'no_name' : title.to_s
      title = title.downcase.gsub(/ /, '_')
      new_title = [title, number == 1 ? nil : number].compact.join('_')

      node = block.call(new_title)
      target = parent || Safe::Tree.root
      begin
        target << node
        node
      rescue Error::AlreadyExist => e
        try_convertion(title, parent, number + 1, &block)
      end
    end
  end

  class Group
    attr_accessor :title, :parent
    def initialize(title, parent)
      @title = title
      @parent = parent
    end

    def convert
      ConvertionHelper.try_convertion(@title, @parent) do |new_title|
        Safe::Dir.new(new_title)
      end
    end
  end

  class Entry
    attr_accessor :title, :username, :password, :url, :comment, :creation, :lastaccess, :lastmod, :expire, :parent
    def initialize(title, username, password, url, comment, creation, lastaccess, lastmod, expire, parent)
      @title = title
      @username = username
      @password = password
      @url = url
      @comment = comment
      @creation = creation
      @lastaccess = lastaccess
      @lastmod = lastmod
      @expire = expire
      @parent = parent
    end

    def convert
      ConvertionHelper.try_convertion(@title, @parent) do |new_title|
        entry = Safe::Entry.new(new_title)
        entry.username = @username.to_s
        entry.password = @password.to_s
        entry.password_confirmation = @password.to_s
        entry.comment = @comment.to_s.gsub("<br></br>", "\n")
        entry.website = @url.to_s
        entry.created_at = @creation
        entry.modified_at = @lastmod
        entry
      end
    end
  end
end
