# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thousand_island/version'

Gem::Specification.new do |spec|
  spec.name          = 'thousand_island'
  spec.version       = ThousandIsland::VERSION
  spec.authors       = ['Colin Weight']
  spec.email         = ['colin@colinweight.com.au']
  spec.description   = %q{Dressing for Prawn}
  spec.summary       = %q{A library that helps with common layout elements in PDFs.}
  spec.homepage      = 'https://github.com/colinweight/thousand_island'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_dependency 'prawn', '~> 1.3.0'
  spec.add_dependency 'prawn-table', '~> 0.2.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard', '~> 2.6.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.3.1'
  spec.add_development_dependency 'pdf-inspector', '~> 1.2.0'
  spec.add_development_dependency 'yard', '~> 0.9.20'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
