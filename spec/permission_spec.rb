require 'spec_helper'

describe RouteAuthorizer::Permission do

  let(:permission_class) { Class.new }
  let(:permission) { permission_class.new(@role) }

  before do
    @role = :admin
    permission_class.include(RouteAuthorizer::Permission)
  end

  it 'returns no permission for no role' do
    @role = nil
    expect(permission.send(:role_permissions)).to eq([])
  end

  it 'returns no permission by default' do
    expect(permission.send(:role_permissions)).to eq([])
  end

  it 'returns default permissions' do
    allow(permission).to receive(:default).and_return [1]
    expect(permission.send(:role_permissions)).to eq [1]
  end

  it 'returns role permissions' do
    allow(permission).to receive(:admin).and_return [2]
    expect(permission.send(:role_permissions)).to eq [2]
  end

  it 'returns default and role permissions' do
    allow(permission).to receive(:default).and_return [1]
    allow(permission).to receive(:admin).and_return [2]
    expect(permission.send(:role_permissions)).to eq [1, 2]
  end

  it 'permits define permission to all controllers and actions' do
    allow(permission).to receive(:admin).and_return [[:all]]
    expect(permission.redirect_to? :any, :any).to be_truthy
  end

  it 'permits define permission to a specific controller and all actions' do
    allow(permission).to receive(:admin).and_return [[:some, :all]]
    expect(permission.redirect_to? :some, :any).to be_truthy
    expect(permission.redirect_to? :other, :any).to be_falsey
  end

  it 'permits define permission to a specific controller and action' do
    allow(permission).to receive(:admin).and_return [[:some, :some]]
    expect(permission.redirect_to? :some, :some).to be_truthy
    expect(permission.redirect_to? :some, :any).to be_falsey
    expect(permission.redirect_to? :any, :any).to be_falsey
  end

end
