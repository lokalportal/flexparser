module Xtractor
  #
  # The ClassMethods defined on the including base.
  #
  module ClassMethods
    #
    # Applies the previously set up node-structure to the given xml
    # and returns Instances of the including Class.
    #
    def parse(xml, _options = {})
      return if parsers.empty?
      @doc = FragmentBuilder.build(xml)
      new.tap do |instance|
        parsers.each do |parser|
          instance.public_send("#{parser.method_name}=", parser.parse(@doc))
        end
      end
    end

    # no-doc
    def parsers
      @parsers ||= []
    end

    protected

    #
    # Defines a CollectionParser belonging to the including class.
    # @see self#node
    # @param sub_parser [Xtractor] a class that defines the `#parse` method that
    #   can deal with the data it receives.
    #
    def collection(tags, **opts, &block)
      add_parser(CollectionParser, tags, opts, &block)
    end

    #
    # Defines a TagParser belonging to the including class.
    # This Tag parser is used in #parse to parse a piece of xml.
    # @param name [String|Symbol] used to name the accessors with which
    #   the parsed info will be accessed.
    # @param xpath [String] a xpath-string used to access a given node.
    #
    #
    def node(tags, **opts, &block)
      add_parser(TagParser, tags, opts, &block)
    end

    def add_parser(klass, tags, **opts, &block)
      tags = Array(tags).flatten
      define_accessors(opts[:name] || tags.first)
      opts[:sub_parser] = new_parser(&block) if block_given?
      parsers << klass.new(tags, opts)
    end

    def new_parser(&block)
      klass = Class.new(AnonymousParser)
      klass.instance_eval(&block)
      klass
    end

    def define_accessors(name)
      attr_accessor name.to_s.gsub(/[[:punct:]]|-/, '_')
    end
  end
end
