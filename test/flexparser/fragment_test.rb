require 'test_helper'

module Flexparser
  class FragmentTest < Minitest::Test
    def xml
      <<-XML
        <parts>
          #{alice_xml}

          #{bob_xml}
        </parts>
      XML
    end

    def alice_xml
      <<-XML
        <!-- Alice's Auto Parts Store -->
        <inventory xmlns="http://alicesautoparts.com/">
          <tire>all weather</tire>
          <tire>studded</tire>
          <tire>extra wide</tire>
        </inventory>
      XML
    end

    def bob_xml
      <<-XML
        <!-- Bob's Bike Shop -->
        <inventory xmlns="http://bobsbikes.com/">
          <tire>street</tire>
          <tire>mountain</tire>
        </inventory>
      XML
    end

    def bob_fragment
      fragment(bob_xml)
    end

    def alice_fragment
      fragment(alice_xml)
    end

    def fragment(str = xml, namespaces: {})
      Fragment.new(str, namespaces: namespaces)
    end

    def test_empty_namespaces
      assert_equal fragment('').pns, {}
    end

    def test_given_namespaces
      assert_equal fragment(alice_xml).pns, 'xmlns' => 'http://alicesautoparts.com/'
      assert_equal fragment(bob_xml).pns, 'xmlns' => 'http://bobsbikes.com/'
    end

    def test_nested_namespaces
      assert_equal fragment(alice_fragment).pns, fragment(alice_xml).pns
      assert_equal fragment(bob_fragment).pns, fragment(bob_xml).pns
    end
  end
end
