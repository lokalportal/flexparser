require 'xpath'
require 'nokogiri'
require 'forwardable'

require 'xtractor/version'
require 'xtractor/fragment'
require 'xtractor/empty_fragment'
require 'xtractor/fragment_builder'
require 'xtractor/tag_parser'
require 'xtractor/collection_parser'
require 'xtractor/class_methods'
require 'xtractor/anonymous_parser'

#
# Main module that, when included, provides
# the including class access to the node building
# structure.
#
module Xtractor
  def self.included(base)
    base.extend ClassMethods
  end
end
