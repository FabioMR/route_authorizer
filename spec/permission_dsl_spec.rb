require 'spec_helper'

describe RouteAuthorizer::PermissionDSL do

  let(:permission_class) { Class.new }
  let(:permission) { permission_class.new }

  before do
    permission_class.include(RouteAuthorizer::PermissionDSL)
  end

  it '.all_roles' do
    expect(permission_class).to receive(:role).with(:default).and_yield

    permission_class.send(:all_roles) { :anything }
  end

  context '.role' do
    it 'with no permission' do
      permission_class.send(:role, :admin) {}

      expect(permission.send(:admin)).to eq([])
    end

    it 'with all permission' do
      permission_class.send(:role, :admin) do
        permit_all
      end

      expect(permission.send(:admin)).to eq([[:all]])
    end

    it 'with controller permission' do
      permission_class.send(:role, :admin) do
        permit :controller1
        permit :controller2
      end

      expect(permission.send(:admin)).to eq([
        [:controller1, :all],
        [:controller2, :all],
      ])
    end

    it 'with controller and action permissions' do
      permission_class.send(:role, :admin) do
        permit :controller1, only: [:action1]
        permit :controller2, only: [:action1, :action2]
      end

      expect(permission.send(:admin)).to eq([
        [:controller1, :action1],
        [:controller2, :action1],
        [:controller2, :action2],
      ])
    end
  end

end
