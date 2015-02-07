require 'spec_helper'

describe RouteAuthorizer::Authorizer do

  it 'extends active support concern' do
    included_modules = RouteAuthorizer::Authorizer.singleton_class.included_modules
    expect(included_modules).to be_include ActiveSupport::Concern
  end

end
