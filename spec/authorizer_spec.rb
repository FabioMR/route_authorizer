require 'spec_helper'

Permission = Object.new

describe RouteAuthorizer::Authorizer do

  let(:role) { :admin }
  let(:current_user) { double('User', role: role) }
  let(:permission) { double('permission', redirect_to?: true) }
  let(:controller) { ActionController::Base.new }

  before do
    allow(Permission).to receive(:new) { permission }

    allow(controller).to receive(:controller_name) { :controller }
    allow(controller).to receive(:action_name) { :action }
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
    before do
      expect(permission).to receive(:redirect_to?).with(:controller, :action) { true }
    end

    it 'raises no exception' do
      expect {controller.send(:authorize_user!)}.not_to raise_error
    end
  end

  context 'when user does not have permission' do
    before do
      expect(permission).to receive(:redirect_to?).with(:controller, :action) { false }
    end

    it 'raises AccessDenied exception' do
      expect {controller.send(:authorize_user!)}.to raise_error(RouteAuthorizer::Authorizer::AccessDenied)
    end
  end

  it '#can_redirect_to?' do
    expect(permission).to receive(:redirect_to?).with(:other_controller, :other_action)
    controller.send(:can_redirect_to?, :other_controller, :other_action)
  end

  it '#can_redirect_to_path?' do
    expect(Rails).to receive_message_chain(:application, :routes, :recognize_path).with('path') { {a: 1, b: 2, c: 3} }
    expect(permission).to receive(:redirect_to?).with(1, 2)
    controller.send(:can_redirect_to_path?, 'path')
  end

end
