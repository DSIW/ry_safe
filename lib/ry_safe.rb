#!/usr/bin/env ruby
# encoding: utf-8

module RySafe
  # Autoloadings
  autoload :Error, "ry_safe/error"

  autoload :Safe, "ry_safe/safe"
  module Util
    autoload :Hashable, "ry_safe/util/hashable"
    autoload :Dates, "ry_safe/util/dates"
    autoload :NodeHandler, "ry_safe/util/node_handler"
    autoload :Safeable, "ry_safe/util/safeable"
    autoload :Cloneable, "ry_safe/util/cloneable"
  end
  module Validators
    autoload :Validator, "ry_safe/validators/validator"
    autoload :PasswordValidator, "ry_safe/validators/password_validator"
  end
  autoload :Path, "ry_safe/path"
  autoload :Shell, "ry_safe/shell"
  autoload :Password, "ry_safe/password"
  autoload :PasswordGenerator, "ry_safe/password_generator"
  autoload :AlphabetGenerator, "ry_safe/alphabet_generator.rb"
  autoload :UnsimilarAlphabetGenerator, "ry_safe/alphabet_generator.rb"

  module Command
    autoload :Commands, "ry_safe/shell/command.rb"
    autoload :Base, "ry_safe/shell/command.rb"
    autoload :Touch, "ry_safe/shell/command.rb"
    autoload :MkDir, "ry_safe/shell/command.rb"
  end

  autoload :Path, "ry_safe/shell/path.rb"
  autoload :RelativePath, "ry_safe/shell/path.rb"
  autoload :AbsolutePath, "ry_safe/shell/path.rb"
end
