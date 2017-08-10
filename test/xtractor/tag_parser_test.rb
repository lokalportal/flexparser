require 'test_helper'

module Flexparser
  class TagParserTest < Minitest::Test
    def parser(tags = %w(bookstore), **opts)
      TagParser.new(tags, opts)
    end

    def model(&block)
      klass = Class.new(AnonymousParser)
      klass.instance_eval(&block)
      klass
    end

    def test_xpaths_rendering
      assert_equal parser.xpaths.xpaths.count, 2
    end

    def test_single_tag
      tag = Nokogiri::XML('<title>James</title>')
      assert_equal parser(%w(title)).parse(tag), 'James'
    end

    def test_subparser
      sub_parser = model do
        property 'title'
      end
      main_parser = parser(%w(book), sub_parser: sub_parser)
      tag = Nokogiri::XML(' <book>
                              <title>James</title>
                            </book> ')
      assert_equal main_parser.parse(tag).title, 'James'
    end
  end
end
