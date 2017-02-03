# frozen_string_literal: true

module Xtractor
  #
  # A parser for a single tag.
  #
  class TagParser
    #
    # @param name [Symbol] the name used for the accessor
    #   defined on the parent.
    # @param xpath [String] an xpath string used to access a Nokogiri-Fragment
    #
    def initialize(tags, **opts)
      @tags    = tags
      @options = opts
    end

    #
    # @param doc [Nokogiri::Node] a node that can be accessed through xpath
    # @return a String if no type was specified, otherwise the type
    #   will try to parse the string using ::parse
    #
    def parse(doc)
      return options[:sub_parser].parse(content(doc)) if sub_parser
      type ? transform(content(doc).text) : content(doc).text
    end

    def name
      options[:name] || tags.first
    end

    def xpaths
      @xpaths ||= tags.map do |t|
        XPath.current.descendant(t.to_sym)
      end.map(&:to_s)
    end

    protected

    def sub_parser
      options[:sub_parser]
    end

    def type
      options[:type]
    end

    def transform(string)
      options[:type].parse string
    end

    def content(doc)
      xpaths.each do |path|
        set = doc.xpath(path)
        return set unless set.empty?
      end
      return unless options[:required]
      raise_required_error(doc)
    end

    def raise_required_error(doc)
      raise(RequiredMissingError.new(self),
            "Required field #{tags} not found in #{doc}")
    end

    attr_accessor :tags, :options
  end
end
