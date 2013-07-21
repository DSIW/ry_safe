# encoding: utf-8

class RySafe::Commands::DSLCommands
  extend Commands::DSL

  command :touch do |c|
    c.action { |path| Safe::Tree.current << Safe::Entry.new(path) }
    c.help_summary { "Create an new entry in current directory" }
  end

  command :ls do |c|
    c.action do |path|
      node = Util::CommandHelper.relative_path_to_existing_node(path || ".")
      puts node.presenter.children
    end
    c.help_summary { "List all items in current directory"}
  end
end
