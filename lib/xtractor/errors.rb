module Xtractor
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
end
