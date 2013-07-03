# encoding: utf-8

module RySafe::Util
  module Presentable
    def presenter_finder
      @presenter ||= PresenterFinder.new(self)
    end

    def presenter
      presenter_finder.presenter
    end

    class PresenterFinder
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def class_name
        object.class.name
      end

      def presenter_name
        "#{class_name}Presenter"
      end

      def presenter_class
        Object.const_get(presenter_name)
      rescue NameError => e
        raise Error::NoPresenterFound, "Presenter #{presenter_name} not found."
      end

      def presenter
        presenter_class.new(object)
      end
    end
  end
end
