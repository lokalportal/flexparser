require 'test_helper'

module Flexparser
  class AttributeExtractionTest < Minitest::Test
    def xml
      <<-XML
      <frame>
        <image url="www.my-image.com" width="430"></image>
        <picture url="www.wrong-url.com">
          <realImage url="www.right-url.com"></realImage>
        </picture>
      </frame>
      XML
    end

    def img_parser
      Class.new do
        include Flexparser

        property '@url'
        property %w[size @width], transform: :to_i
        property 'realImage/@url', name: :super_url
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

    def test_finds_specific_url
      assert_equal image.super_url, 'www.right-url.com'
    end
  end
end
