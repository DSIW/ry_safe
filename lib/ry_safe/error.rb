module RySafe::Error
  #class MustOverride < Exception
  #  def initialize(method)
  #    super("Must override method: #{method}")
  #  end
  #end

  #class NotSetup < Exception
  #  def to_s; "Must call 'AppConfig.setup' to setup storage!"; end
  #end
  class NotNode < ArgumentError; end
  class SourceNotNode < NotNode; end
  class DestinationNotNode < NotNode; end

  class NotMovable < StandardError; end
  class NotCopyable < StandardError; end
  class NotRemovable < StandardError; end
end
