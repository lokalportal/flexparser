module Flexparser
  #
  # A semi-anonymous class used for building the node
  # structure.
  #
  class AnonymousParser
    extend ClassMethods

    def to_s
      return super if self.class.parsers.empty?
      to_h.to_s
    end

    def to_h
      self.class.parsers.each_with_object({}) do |parser, hash|
        hash[parser.name.to_sym] = public_send(parser.name)
      end
    end
  end
end
