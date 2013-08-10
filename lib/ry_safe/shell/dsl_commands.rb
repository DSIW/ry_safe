# encoding: utf-8

class RySafe::Commands::DSLCommands
  extend Commands::DSL

  command :touch do |c|
    c.action { |path| Safe::Tree.current << Safe::Entry.new(path) }
    c.help_summary { "Create an new entry in current directory" }
  end

  command :ls do |c|
    c.argument(0) { |arg| Util::CommandHelper.relative_path_to_existing_node(arg || ".") }
    c.action { |node| puts node.presenter.children }
    c.help_summary { "List all items in current directory" }
  end

  command :mkdir do |c|
    c.action { |name| Safe::Tree.current << Safe::Dir.new(name) }
    c.help_summary { "Create an new directory in current directory" }
  end

  command :cd do |c|
    c.action { |path| Safe::Tree.current = Util::CommandHelper.relative_path_to_existing_node(path) }
    c.help_summary { "Change current directory to the specified directory" }
  end

  command :cp do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.argument(1, :relative_path_to_existing_node)
    c.action { |source, destination| Util::NodeHandler.copy(source, destination) }
    c.help_summary { "Copy item to another directory" }
  end

  command :mv do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.argument(1, :relative_path_to_existing_node)
    c.action { |source, destination| Util::NodeHandler.move(source, destination) }
    c.help_summary { "Move item to another directory" }
  end

  command :rm do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.action { |node| Util::NodeHandler.remove(node) }
    c.help_summary { "Remove directory or entry" }
  end

  command :cat do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.action { |path| puts path.presenter.content }
    c.help_summary { "Show specified entry" }
  end

  command :set do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.argument(1) { |arg| splitted = arg.split('='); OpenStruct.new(key: splitted.first, value: splitted.last) }
    c.action do |node, setting|
      node.send("#{setting.key}=", setting.value)
      puts "Saved"
    end
    c.help_summary { "Set option to specified entry" }
  end

  command :get do |c|
    c.argument(0, :relative_path_to_existing_node)
    c.action { |node, attribute| puts node.send(attribute)}
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
    c.argument(0, :relative_path_to_existing_node)
    c.action do |path, new_name|
      path.name = new_name
      puts "Renamed to #{new_name}"
    end
    c.help_summary { "Rename current entry oder directory" }
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
    c.argument(0) { |arg| arg.to_i }
    c.argument(1) { |arg| arg.to_i }
    c.action do |length, count, *options|
      options = options.map { |option| option.split('=') }
        .reduce({}) do |hash, (option, value)|
          hash.merge(option.to_sym => value)
        end
      passwords = RySafe::PasswordGenerator.new(length, options).generate(count)
      puts passwords.map(&:inspect).join("\n")
    end
    c.help_summary { "Generate new passwords" }
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
