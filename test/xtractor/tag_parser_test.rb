require 'test_helper'

module Xtractor
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
      assert_equal parser.xpaths.count, 1
      assert_equal parser.xpaths, ['.//bookstore']
    end

    def test_single_tag
      tag = Nokogiri::XML('<title>James</title>')
      assert_equal parser(%w(title)).parse(tag), 'James'
    end

    def test_subparser
      sub_parser = model do
        node 'title'
      end
      main_parser = parser(%w(book), sub_parser: sub_parser)
      tag = Nokogiri::XML(' <book>
                              <title>James</title>
                            </book> ')
      assert_equal main_parser.parse(tag).title, 'James'
    end
  end
end