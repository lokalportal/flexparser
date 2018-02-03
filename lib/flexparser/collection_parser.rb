module Flexparser
  #
  # A Parser similar to the TagParser but intendet for a collection
  # of properties.
  # @param sub_parser [Wrench] all CollectionParsers need a subparser to
  #   deal with the content of the nodes parsed. This should ideally be
  #   a class that includes Spigots::Wrench and can parse the fragment it
  #   is dealt.
  #
  class CollectionParser < TagParser
    #
    # @param doc [Nokogiri::Node] a node that can be accessed through xpath
    # @return [Array<Object>] An array of String if no type was specified,
    # otherwise the type will try to parse the string using ::parse
    #
    def parse(doc)
      content(doc).map do |n|
        next sub_parser.parse(n) if sub_parser
        next type.parse(n.text) if type
        n.text
      end
    end

    protected

    def content(doc)
      content = doc.xpath(xpaths.valid_paths(doc).reduce(&:union).to_s)
      return content unless content.empty?
      options[:required] ? raise_required_error(doc) : content
    end
  end
end
