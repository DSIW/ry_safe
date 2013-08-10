# encoding: utf-8

require "nori"

module RySafe::Import
  class KeePassXImporter < Importer
    def import
      GroupNode.new(root, nil).import
    end

    private

    def root
      file_to_hash[:database]
    end

    def file_to_hash
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      parser.parse(file_content)
    end
  end

  GroupNode = Struct.new(:hash, :parent) do
    def import
      convert
      import_entries(to_array(hash[:entry])) if hash[:entry]
      import_groups(to_array(hash[:group])) if hash[:group]
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

  Group = Struct.new(:title, :parent) do
    def convert
      dir = Safe::Dir.new(title || '--', parent)
      puts "#{"  "*dir.parents.length}#{dir.name}"
      dir.save
      dir
    end
  end

  Entry = Struct.new(:title, :username, :password, :url, :comment, :creation, :lastaccess, :lastmod, :expire, :parent) do
    def convert
      entry = Safe::Entry.new(title || '--', parent)
      entry.username = username
      entry.password = password
      entry.password_confirmation = password
      entry.comment = comment
      entry.website = url
      puts "#{"  "*entry.parents.length}#{entry.name}"
      entry.save
      entry
    end
  end
end
