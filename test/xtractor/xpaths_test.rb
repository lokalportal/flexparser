# frozen_string_literal: true

require 'test_helper'

module Xtractor
  class XPathsTest
    def test_method_name
      xpaths = XPaths.new(%w[@url link])
      assert_equal xpaths.method_name, 'url'
    end

    def test_xpaths
      xpaths = XPaths.new(%w[james content:encoded url])
      assert_equal xpaths.xpaths.length, 5
      assert xpaths.xpaths.include?(".//*[name(.) = 'james']")
    end
  end
end
