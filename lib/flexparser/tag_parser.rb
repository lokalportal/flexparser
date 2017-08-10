# frozen_string_literal: true

module Flexparser
  #
  # A parser for a single tag.
  #
  class TagParser
    attr_accessor :xpaths, :options

    #
    # @param name [Symbol] the name used for the accessor
    #   defined on the parent.
    # @param xpath [String] an xpath string used to access a Nokogiri-Fragment
    #
    def initialize(tags, **opts)
      @xpaths  = XPaths.new(tags)
      @options = opts
    end

    #
    # @param doc [Nokogiri::Node] a node that can be accessed through xpath
    # @return a String if no type was specified, otherwise the type
    #   will try to parse the string using ::parse
    #
    def parse(doc)
      result = content(doc) || return
      return options[:sub_parser].parse(result) if sub_parser
      type ? transform(result.text) : result.text
    end

    def name
      options[:name] || xpaths.method_name
    end

    protected

    def sub_parser
      options[:sub_parser]
    end

    def type
      options[:type] || options[:transform]
    end

    def transform(string)
      return options[:type].parse string if options[:type]
      return string.public_send(options[:transform]) if options[:transform]
      string
    end

    def content(doc)
      xpaths.valid_paths(doc).each do |path|
        set = doc.xpath("(#{path})[1]")
        return set unless set.empty?
      end
      return unless options[:required]
      raise_required_error(doc)
    end

    def raise_required_error(doc)
      raise(RequiredMissingError.new(self),
            "Required field #{name} not found in #{doc}")
    end
  end
end
