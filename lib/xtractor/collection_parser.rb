module Xtractor
  #
  # A Parser similar to the TagParser but intendet for a collection
  # of nodes.
  # @param sub_parser [Wrench] all CollectionParsers need a subparser to
  #   deal with the content of the nodes parsed. This should ideally be
  #   a class that includes Spigots::Wrench and can parse the fragment it
  #   is dealt.
  #
  class CollectionParser < TagParser
    def parse(doc)
      content(doc).map do |n|
        next sub_parser.parse(n) if sub_parser
        next type.parse(n.text) if type
        n.text
      end
    end

    def xpaths
      @xpaths ||= tags.map do |t|
        XPath.current.descendant(t.to_sym)
      end.reduce(&:union).to_s
    end

    protected

    def content(doc)
      content = doc.xpath(xpaths)
      return content unless content.empty?
      options[:required] ? raise_required_error(doc) : content
    end
  end
end
