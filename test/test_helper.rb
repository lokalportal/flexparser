$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'flexparser'

require 'minitest/autorun'

Flexparser.configure do |config|
  config.explicit_property_naming = false
end
