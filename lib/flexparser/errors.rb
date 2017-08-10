module Flexparser
  class Error < StandardError; end

  #
  # An Error that will be thrown if a value is required but
  # missing.
  #
  class RequiredMissingError < Error
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end
  end

  #
  # An Error that is thrown when there is no clear name
  #   for a property.
  #
  class AmbiguousNamingError < ArgumentError; end
end
