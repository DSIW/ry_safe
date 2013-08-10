module RySafe
  # Autoloadings
  autoload :Error, "ry_safe/error"

  autoload :Safe, "ry_safe/safe"

  module Util
    autoload :Hashable, "ry_safe/util/hashable"
    autoload :Dates, "ry_safe/util/dates"
    autoload :NodeHandler, "ry_safe/util/node_handler"
    autoload :Visible, "ry_safe/util/visible"
    autoload :Cloneable, "ry_safe/util/cloneable"
    autoload :Register, "ry_safe/util/register"
    autoload :Presentable, "ry_safe/util/presentable"
    autoload :PresenterHelper, "ry_safe/util/presenter_helper"
    autoload :CommandHelper, "ry_safe/util/command_helper"
    autoload :Persistable, "ry_safe/util/persistable"
  end

  module Validators
    autoload :Validator, "ry_safe/validators/validator"
    autoload :PasswordValidator, "ry_safe/validators/password_validator"
  end

  autoload :Path, "ry_safe/path"
  autoload :Shell, "ry_safe/shell/shell"
  autoload :Password, "ry_safe/password"
  autoload :PasswordGenerator, "ry_safe/password_generator"
  autoload :AlphabetGenerator, "ry_safe/alphabet_generator.rb"
  autoload :UnsimilarAlphabetGenerator, "ry_safe/alphabet_generator.rb"

  module Commands
    autoload :Base, "ry_safe/shell/commands.rb"
    autoload :Dispatcher, "ry_safe/shell/commands.rb"
    autoload :Commands, "ry_safe/shell/commands.rb"

    autoload :DSL, "ry_safe/shell/command_dsl.rb"
    autoload :DSLCommands, "ry_safe/shell/dsl_commands.rb"
    module DSL
      autoload :CommandBuilder, "ry_safe/shell/dsl_commands.rb"
      autoload :Argument, "ry_safe/shell/dsl_commands.rb"
      autoload :Commands, "ry_safe/shell/dsl_commands.rb"
    end
  end

  autoload :Path, "ry_safe/shell/path.rb"
  autoload :RelativePath, "ry_safe/shell/path.rb"
  autoload :AbsolutePath, "ry_safe/shell/path.rb"

  autoload :Presenter, "ry_safe/presenters/presenter.rb"
  autoload :EntryPresenter, "ry_safe/presenters/entry_presenter.rb"
  autoload :NodePresenter, "ry_safe/presenters/node_presenter.rb"
  autoload :DirPresenter, "ry_safe/presenters/dir_presenter.rb"
  autoload :TreePresenter, "ry_safe/presenters/tree_presenter.rb"

  module Persistence
    autoload :Base, "ry_safe/persistence/base.rb"
    autoload :File, "ry_safe/persistence/file.rb"
    autoload :Tree, "ry_safe/persistence/tree.rb"
    autoload :History, "ry_safe/persistence/history.rb"
    autoload :Config, "ry_safe/persistence/config.rb"
  end

  module Import
    autoload :Importer, "ry_safe/import/importer.rb"
    autoload :KeePassXImporter, "ry_safe/import/kee_pass_x_importer.rb"
  end

  autoload :Main, "ry_safe/main.rb"
end
