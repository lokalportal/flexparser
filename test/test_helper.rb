$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'xtractor'

require 'minitest/autorun'

Xtractor.configure do |config|
  config.explicit_property_naming = false
end
