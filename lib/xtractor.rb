require 'xpath'
require 'nokogiri'
require 'forwardable'

require 'xtractor/version'
require 'xtractor/configuration'
require 'xtractor/fragment'
require 'xtractor/xpaths'
require 'xtractor/empty_fragment'
require 'xtractor/fragment_builder'
require 'xtractor/tag_parser'
require 'xtractor/collection_parser'
require 'xtractor/class_methods'
require 'xtractor/anonymous_parser'

#
# Main module that, when included, provides
# the including class access to the property building
# structure.
#
module Xtractor
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
