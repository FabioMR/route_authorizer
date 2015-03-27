require 'spec_helper'

describe RouteAuthorizer::Authorizer do

  let(:role) { :admin }
  let(:current_user) { double('User', role: role) }
  let(:permission) { double('permission', permit?: true) }
  let(:controller) { ActionController::Base.new }

  before do
    allow(Permission).to receive(:new) { permission }

    allow(controller).to receive(:controller_path) { 'controller' }
    allow(controller).to receive(:action_name) { 'action' }
    allow(controller).to receive(:current_user) { current_user }
  end

  context 'when has a current user' do
    before do
      expect(Permission).to receive(:new).with(role)
    end

    it 'returns current user role' do
      controller.send(:permission)
    end
  end

  context 'when does not have a current user' do
    before do
      allow(controller).to receive(:current_user) { nil }
    end

    it 'returns no role' do
      expect(Permission).to receive(:new).with(nil)
      controller.send(:permission)
    end
  end

  context 'when user has permission' do
    context 'with namespace' do
      before do
        allow(controller).to receive(:controller_path) { 'admin/controller' }
      end

      it 'raises no exception' do
        expect(permission).to receive(:permit?).with('admin_controller', 'action') { true }
        expect {controller.send(:authorize_user!)}.not_to raise_error
      end
    end

    context 'without namespace' do
      it 'raises no exception' do
        expect(permission).to receive(:permit?).with('controller', 'action') { true }
        expect {controller.send(:authorize_user!)}.not_to raise_error
      end
    end
  end

  context 'when user does not have permission' do
    it 'raises AccessDenied exception' do
      expect(permission).to receive(:permit?).with('controller', 'action') { false }
      expect {controller.send(:authorize_user!)}.to raise_error(RouteAuthorizer::Authorizer::AccessDenied)
    end
  end

  it '#permit?' do
    expect(permission).to receive(:permit?).with('other_controller', 'other_action')
    controller.send(:permit?, 'other_controller', 'other_action')
  end

  it '#permit_path?' do
    expect(Rails).to receive_message_chain(:application, :routes, :recognize_path).with('path') { {a: 1, b: 2, c: 3} }
    expect(permission).to receive(:permit?).with(1, 2)
    controller.send(:permit_path?, 'path')
  end

end
