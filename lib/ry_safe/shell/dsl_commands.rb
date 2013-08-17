# encoding: utf-8

class RySafe::Commands::DSLCommands
  extend Commands::DSL

  command :touch do |c|
    c.action do |path|
      node = Safe::Entry.new(path)
      Safe::Tree.current << node
      View::EntryEditor.new(node).new
    end
    c.help_summary { "Create an new entry in current directory" }
  end

  command :edit do |c|
    c.action do |path|
      entry = Util::CommandHelper.relative_path_to_existing_node(path)
      View::EntryEditor.new(entry).edit
    end
    c.help_summary { "Edit an attribute of entry" }
  end

  command :ls do |c|
    c.action do |path|
      node = Util::CommandHelper.relative_path_to_existing_node(path || ".")
      puts node.presenter.children
    end
    c.help_summary { "List all items in current directory" }
  end

  command :mkdir do |c|
    c.action { |name| Safe::Tree.current << Safe::Dir.new(name) }
    c.help_summary { "Create an new directory in current directory" }
  end

  command :cd do |c|
    c.action do |path|
      node = Util::CommandHelper.relative_path_to_existing_node(path || "/")
      case node
      when Safe::Dir
        Safe::Tree.current = node
      else
        puts "Node has to be a directory"
      end
    end
    c.help_summary { "Change current directory to the specified directory" }
  end

  command :cp do |c|
    c.action do |source_path, destination_path|
      source = Util::CommandHelper.relative_path_to_existing_node(source_path)
      destination = Util::CommandHelper.relative_path_to_existing_node(destination_path)
      Util::NodeHandler.copy(source, destination)
    end
    c.help_summary { "Copy item to another directory" }
  end

  command :mv do |c|
    c.action do |source_path, destination_path|
      source = Util::CommandHelper.relative_path_to_existing_node(source_path)
      destination = Util::CommandHelper.relative_path_to_existing_node(destination_path)
      Util::NodeHandler.move(source, destination)
    end
    c.help_summary { "Move item to another directory" }
  end

  command :rm do |c|
    c.action do |path|
      node = Util::CommandHelper.relative_path_to_existing_node(path)
      Util::NodeHandler.remove(node)
    end
    c.help_summary { "Remove directory or entry" }
  end

  command :cat do |c|
    c.action do |path|
      node = Util::CommandHelper.relative_path_to_existing_node(path || ".")
      puts node.presenter.content
    end
    c.help_summary { "Show specified entry" }
  end

  command :set do |c|
    c.action do |path, setting|
      node = Util::CommandHelper.relative_path_to_existing_node(path)
      key, value = setting.split('=')
      node.send("#{key}=", value)
      puts "Saved"
    end
    c.help_summary { "Set option to specified entry" }
  end

  command :get do |c|
    c.action do |path, attribute|
      node = Util::CommandHelper.relative_path_to_existing_node(path)
      puts node.send(attribute)
    end
    c.help_summary {"Read option from specified entry"}
  end

  command :pwd do |c|
    c.action { puts Safe::Tree.current.presenter.path }
    c.help_summary {"Print the current directory path"}
  end

  command :clear do |c|
    c.action {puts "\n"*40}
    c.help_summary {"Clear console"}
  end

  command :rename do |c|
    c.action do |path, new_name|
      node = Util::CommandHelper.relative_path_to_existing_node(path)
      node.name = new_name
      puts "Renamed to #{new_name}"
    end
    c.help_summary { "Rename current entry oder directory" }
  end

  command :find do |c|
    c.action do |pattern|
      found_nodes = Safe::Tree.root.find(Regexp.new(pattern, true))
      puts found_nodes.map { |node| node.presenter.path }.join("\n")
    end
    c.help_summary { "Search through all nodes and find title which matches the given pattern" }
  end

  command :exit do |c|
    c.action { exit }
    c.help_summary { "Exit RySafe console" }
  end

  command :reload! do |c|
    c.action do
      files = Dir["#{File.dirname(__FILE__)}/../../**/*.rb"]
      files.each do |file|
        begin
          load file
        rescue Exception => e
        end
      end
      puts "Reloaded!"
    end
    c.help_summary { "Reload RySafe for debugging" }
  end

  command :help do |c|
    c.action do
      commands = Commands::Commands.all.map { |command|
        "#{command.name}: #{command.help_summary}"
      }.join("\n")
      puts "All available commands are:\n\n#{commands}"
    end
    c.help_summary { "Show this help message" }
  end

  command :version do |c|
    c.action { puts "Version: #{RySafe::VERSION}" }
    c.help_summary { "Show version of RySafe" }
  end

  command :gen_passwords do |c|
    c.action do |length, count, *options|
      length = length.to_i
      count = count.to_i
      options = options.map { |option| option.split('=') }
        .reduce({}) do |hash, (option, value)|
          hash.merge(option.to_sym => value)
        end
      passwords = RySafe::PasswordGenerator.new(length, options).generate(count)
      puts passwords.map(&:inspect).join("\n")
    end
    c.help_summary { "Generate new passwords" }
  end

  command :import_keepassx! do |c|
    c.action do |path|
      RySafe::Import::KeePassXImporter.new(path).import
      puts "Importiert!"
    end
    c.help_summary { "Import from KeePassX XML file" }
  end

  command :save! do |c|
    c.action do |path|
      RySafe::Persistence::Tree.new.save
      puts "Saved!"
    end
  end

  command :load! do |c|
    c.action do |path|
      RySafe::Persistence::Tree.new.load
      puts "Loaded!"
    end
  end

  command :safe_passwords! do |c|
    c.action do
      Password.hidden!
      puts "Passwords are hidden"
    end
  end

  command :unsafe_passwords! do |c|
    c.action do
      Password.visible!
      puts "Passwords are visible"
    end
  end
end
