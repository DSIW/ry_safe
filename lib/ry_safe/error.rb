module RySafe::Error
  class NotNode < ArgumentError; end
  class SourceNotNode < NotNode; end
  class DestinationNotNode < NotNode; end
  class NotInTree < ArgumentError; end
  class AlreadyExist < ArgumentError; end

  class NotMovable < StandardError; end
  class NotCopyable < StandardError; end
  class NotRemovable < StandardError; end
end
