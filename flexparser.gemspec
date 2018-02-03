# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flexparser/version'

Gem::Specification.new do |spec|
  spec.name          = 'flexparser'
  spec.version       = Flexparser::VERSION
  spec.authors       = ['Paul Martensen']
  spec.email         = ['paul.martensen@gmx.de']
  spec.licenses      = ['GPL-3.0']
  spec.homepage      = 'https://github.com/lokalportal/flexparser'
  spec.summary       = 'A xml-parser dsl'
  spec.description   = 'A flexible and robust parser-dsl.'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1'
  spec.add_dependency 'xpath', '~> 2'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency 'rubocop', '~> 0.52'
  spec.add_development_dependency 'flay', '~> 2'
end
