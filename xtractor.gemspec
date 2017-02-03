# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xtractor/version'

Gem::Specification.new do |spec|
  spec.name          = 'xtractor'
  spec.version       = Xtractor::VERSION
  spec.authors       = ['Paul Martensen']
  spec.email         = ['paul.martensen@gmx.de']

  spec.summary       = 'A xml-parser dsl'
  spec.description   = 'A flexible and robust parser-dsl.'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'xpath'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
