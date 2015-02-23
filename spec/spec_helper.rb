require 'bundler/setup'
Bundler.require(:default, :development)

Permission = Class.new(RouteAuthorizer::Permission)
