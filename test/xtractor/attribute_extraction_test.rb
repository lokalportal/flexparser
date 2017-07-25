require 'test_helper'

module Xtractor
  class AttributeExtractionTest < Minitest::Test
    def xml
      <<-XML
      <image url="www.my-image.com" width="430"></image>
      XML
    end

    def img_parser
      Class.new do
        include Xtractor

        node '@url'
        node %w[size @width], transform: :to_i
      end
    end

    def image
      img_parser.parse xml
    end

    def test_sets_correct_accessors
      assert image.respond_to?(:url)
      assert image.respond_to?(:url=)
    end

    def test_finds_the_attribute
      assert_equal image.url, 'www.my-image.com'
    end

    def test_finds_attribute_by_correct_name
      assert_equal image.size, 430
    end
  end
end
