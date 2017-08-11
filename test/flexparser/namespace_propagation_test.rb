require 'test_helper'

module Flexparser
  class NamespacePropagationTest < Minitest::Test
    def xml
      <<-XML
        <parts>
          <!-- Alice's Auto Parts Store -->
          <inventory xmlns="http://alicesautoparts.com/">
            <tire>all weather</tire>
            <tire>studded</tire>
            <tire>extra wide</tire>
          </inventory>

          <!-- Bob's Bike Shop -->
          <inventory xmlns="http://bobsbikes.com/">
            <tire>street</tire>
            <tire>mountain</tire>
          </inventory>
        </parts>
      XML
    end

    def pref_xml
      <<-XML
        <channel>
          <rss version="2.0"
          xmlns:blogChannel="http://backend.userland.com/blogChannelModule"
          xmlns:content="http://purl.org/rss/1.0/modules/content/"
          >

          <content:encoded>
            Hey James
          </content:encoded>
        </channel>
      XML
    end

    def parser
      Class.new do
        include ::Flexparser

        property 'parts' do
          property 'inventory', collection: true do
            property 'tire', collection: true
          end
        end
      end
    end

    def pref_parser
      Class.new do
        include ::Flexparser

        property 'content:encoded'
      end
    end

    def feed
      parser.parse xml
    end

    def test_it_handles_namespaces_on_top_level
      assert feed # Does not throw an error
    end

    def test_it_finds_namespaced_properties
      assert_equal feed.parts.inventory.first.tire.count, 3
    end

    def test_prefixed_namespace_propagation
      p_feed = pref_parser.parse(pref_xml)
      assert p_feed.content_encoded
    end
  end
end
