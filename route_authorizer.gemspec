# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'route_authorizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'route_authorizer'
  spec.version       = RouteAuthorizer::VERSION
  spec.authors       = ['Fábio Rodrigues']
  spec.email         = ['fabio.info@gmail.com']
  spec.summary       = 'Simple routes authorization solution for Rails based on user roles.'
  spec.homepage      = 'https://github.com/FabioMR/route_authorizer'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'byebug'
end
