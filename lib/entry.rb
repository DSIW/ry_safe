require './dir'
require './node'
require 'ostruct'

module RubySafe

  module Safe
    class Entry
      include Node

      def initialize name, parent=Dir::ROOT
        super name, parent
      end

      def delete key
        key_sym = key.to_sym
        if key_sym == :name || key_sym == :parent
          throw :UndeletableAttribute
        end
        begin
          instance_eval { remove_instance_variable key_sym }
        rescue NameError
          #key was not there
        end
      end

      def encode_with coder
        instance_variables.each do |var|
          next if var == :@parent
          coder[var.to_s[1..-1]] = instance_variable_get(var)
        end
      end

      def init_with coder
        coder.map.each do |var, val|
          instance_variable_set "@#{var}", val
        end
      end

      def dup
        copy = self.dup
        instance_variables.each do |var|
          value = instance_variable_get var
          if value
            copy.instance_variable_set var, value
          end
        end
        copy.touch
        copy
      end
      
      def method_missing method, *args
        method_name = method.id2name
        case method_name
        when /^name(=)?/, /^parent(=)?/
          return super
        when /=$/
          new_attr = method_name[0..-2].to_sym
          touch
        else
          new_attr = method
        end
        (class << self; self; end).class_eval { attr_accessor new_attr }
        self.send(method, *args)
      end

      private

      def hash_data
        data = @name.dup
        instance_variables.each do |var|
          next if var == :@parent
          data << var.to_s 
          data << instance_variable_get(var)
        end
        data
      end

    end
  end
end
