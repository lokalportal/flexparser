module Xtractor
  #
  # Class to keep config-options for the whole module.
  #
  class Configuration
    AVAILABLE_OPTIONS =
      %i[rety_without_namespaces explicit_property_naming].freeze
    attr_accessor(*AVAILABLE_OPTIONS)

    def initialize
      @rety_without_namespaces  = true
      @explicit_property_naming = true
    end

    def to_h
      Hash[AVAILABLE_OPTIONS.map { |o| [o, public_send(o)] }]
    end
  end
end
