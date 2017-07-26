# frozen_string_literal: true

module Xtractor
  #
  # A class to represent a collection of paths.
  # This class is supposed to be more convenient for
  # handeling a collection of xpaths.
  #
  class XPaths
    attr_accessor :tags

    #
    # @param tags [Array<String>] a list of names for xpaths
    #   that the xpaths instance will handle.
    #
    def initialize(tags)
      @tags = Array(tags).map(&:to_sym).flatten
      raise ArgumentError, arg_err_msg if @tags.empty?
    end

    #
    # The name of an accesor, based on the collection of tags.
    #
    def method_name
      tags.first.to_s.sub(/^@/, '').gsub(/([[:punct:]]|-)+/, '_')
    end

    #
    # Builds xpaths from the given tags
    #
    def xpaths
      @xpaths ||= begin
                    paths = tags.map do |t|
                      XPath.current.descendant(t)
                    end
                    if Xtractor.configuration.retry_without_namespaces
                      paths += ns_ignortant_xpaths
                    end
                    paths
                  end
    end

    #
    # Returns the valid paths from this collection, based on the given doc.
    # @param doc [Xtractor::Fragment] the fragment that carries the namespaces.
    # @return [Array<String>] the xpaths that can be applied to this fragment
    #
    def valid_paths(doc)
      xpaths.reject do |path|
        namespaced?(path) && !namespace_available?(path, doc)
      end
    end

    private

    #
    # Returns xpaths that ignore namespaces.
    #
    def ns_ignortant_xpaths
      tags.reject(&method(:namespaced?)).flat_map do |tag|
        XPath.current.descendant[XPath.name.equals(tag.to_s)]
      end
    end

    #
    # Checks whether a tag has a specified namespace.
    # @param tag [String] The tag to be looked at
    #
    def namespaced?(tag)
      !(tag.to_s =~ /\w+:\w+/).nil?
    end

    #
    # Checks whether or not a path is can be applied to a given fragment.
    # @param path [String] the path that is to be checked
    # @param doc [Xtractor::Fragment] the fragment that carries the namespaces.
    # @return [Boolean] true if the path can be applied, false otherwise.
    #
    def namespace_available?(path, doc)
      nms = doc.propagating_namespaces.keys.map { |ns| ns.gsub('xmlns:', '') }
      path.to_s.match Regexp.union(nms)
    end

    # no-doc
    def arg_err_msg
      'There needs to be at least one path for a path-collection to be valid'
    end
  end
end
