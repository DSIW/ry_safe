module RySafe::Error
  class NotNode < ArgumentError; end
  class SourceNotNode < NotNode; end
  class DestinationNotDir < NotNode; end
  class NotInTree < ArgumentError; end
  class AlreadyExist < ArgumentError; end
  class SameSourceAndDestination < ArgumentError; end
  class NoCommand < ArgumentError; end

  class NoPresenterFound < StandardError; end

  class NotMovable < StandardError; end
  class NotCopyable < StandardError; end
  class NotRemovable < StandardError; end
end
