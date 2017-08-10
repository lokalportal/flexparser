require 'xpath'
require 'nokogiri'
require 'forwardable'

require 'flexparser/version'
require 'flexparser/errors'
require 'flexparser/configuration'
require 'flexparser/fragment'
require 'flexparser/xpaths'
require 'flexparser/empty_fragment'
require 'flexparser/fragment_builder'
require 'flexparser/tag_parser'
require 'flexparser/collection_parser'
require 'flexparser/class_methods'
require 'flexparser/anonymous_parser'

#
# Main module that, when included, provides
# the including class access to the property building
# structure.
#
module Flexparser
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
