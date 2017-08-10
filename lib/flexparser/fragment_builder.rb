module Flexparser
  #
  # Class to build handle turn a given object into
  # a Fragment. Used mostly as a Safeguard.
  #
  class FragmentBuilder
    class << self
      def build(str, namespaces: {})
        return str if str.is_a?(Fragment)
        return EmptyFragment.new(str) if str.nil?
        Fragment.new(str, namespaces: namespaces)
      end
    end
  end
end
