module Flexparser
  #
  # Class to build handle turn a given object into
  # a Fragment. Used mostly as a Safeguard.
  #
  class FragmentBuilder
    class << self
      #
      # @param str [String|Fragment] The object that will be turned into
      #   a Fragment.
      # @return A fragment of some kind. Either the given fragment, a new
      #   normal {Fragment} or en {EmptyFragment}.
      #
      def build(str, namespaces: {})
        return str if str.is_a?(Fragment)
        return EmptyFragment.new(str) if str.nil?
        Fragment.new(str, namespaces: namespaces)
      end
    end
  end
end
