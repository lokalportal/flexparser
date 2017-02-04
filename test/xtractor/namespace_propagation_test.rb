require 'test_helper'

module Xtractor
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

    def parser
      Class.new do
        include ::Xtractor

        node 'parts' do
          collection 'inventory' do
            collection 'xmlns:tire'
          end
        end
      end
    end

    def feed
      parser.parse xml
    end

    def test_it_handles_namespaces_on_top_level
      assert feed # Does not throw an error
    end

    def test_it_finds_namespaced_properties
      assert_equal feed.parts.inventory.first.tires.count, 3
    end
  end
end
