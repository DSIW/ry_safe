module RySafe::Util::CommandHelper
  module_function

  def absolute_path(relative_path, pwd = Safe::Tree.current.path)
    RelativePath.new(relative_path, pwd).to_absolute
  end

  def relative_path_to_node(relative_path, pwd = Safe::Tree.current.path)
    absolute_path(relative_path, pwd).to_node
  end

  def relative_path_to_existing_node(relative_path, pwd = Safe::Tree.current)
    absolute_path(relative_path, pwd.path).to_existing_node_in(Safe::Tree.root)
  end
end
