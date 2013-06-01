require 'readline'
require 'colorize'
require './dir'
require './entry'

module RubySafe
  class Shell

    def initialize
      @pwd = Safe::Dir::ROOT
      @completions = %w[cd ls mkdir rm cat touch rmdir]
      Readline.completion_append_character = " "
      Readline.completion_proc = lambda do |string|
        command = Readline.line_buffer
        if command.split(/\s+/).size == 1
          @completions.grep(/^#{Regexp.escape(string)}/)
        else
          @pwd.ls.map{|item| item.to_s}.grep(/^#{Regexp.escape(string)}/)
        end
      end
    end

    def touch path
      path = pathify path
      if path.basename.is_a? String
        Safe::Entry.new path.basename, path.pwd
      else
        throw :FileExists
      end
    end

    def rm path
      path = pathify path
      path.basename.rm
    end

    def rmdir path
      path = pathify path
      path.basename.rmdir
    end

    def format_ls entries
      lines = []
      index = 0
      entries.each do |entry|
        if lines[index]
          lines[index] << " " << entry
        else
          lines[index] = entry
        end
        if lines[index].size > 80
          index += 1
        end
      end
      lines.join("\n")
    end

    def cat path
      path = pathify path
      unless path.basename.is_a? Entry
        throw :NoSuchFile
      end
      path.basename.to_s
    end

    def cd path
      @pwd = @pwd.cd path
    end

    def ls *args
      colored = @pwd.ls.sort.map do |content|
        string = content.to_s
        if content.is_a? Safe::Dir
          string.colorize :blue
        else
          string
        end
      end
      puts format_ls(colored)
    end

    def mkdir *args
      Safe::Dir.new(args[0], @pwd)
    end

    def pathify string
      if string.empty?
        throw :NoSuchFile
      end
      if string.is_a? String
        Safe::Path.new @pwd, string
      end
    end

    def prompt
      while line = Readline.readline("#{@pwd} > ", true) do
        begin
          eval_command(line)
        rescue StandardError => e
          puts e.message
        end
      end
    end

    def eval_command line
      split = line.split(/\s+/)
      method = split[0]
      args = line.split[1..-1]
      self.send(method, *args)
    end

  end
end

shell = RubySafe::Shell.new
shell.prompt
