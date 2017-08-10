module Flexparser
  #
  # Used as a safeguard when passing nil or an empty string
  # to the FragmentBuilder.
  #
  class EmptyFragment < Fragment
    def xpath(_path)
      self.class.new(nil)
    end

    def empty?
      true
    end

    def text
      nil
    end

    def namespaces
      {}
    end
  end
end
