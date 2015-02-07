module RouteAuthorizer::Authorizer

  extend ActiveSupport::Concern

  class AccessDenied < StandardError; end

  included do
    helper_method :can_redirect_to?, :can_redirect_to_path?
  end

private

  def can_redirect_to?(_controller_name, _action_name)
    Permission.new(current_user.role).redirect_to?(_controller_name, _action_name) if current_user
  end

  def can_redirect_to_path?(path)
    controller_and_action = Rails.application.routes.recognize_path(path).values[0..1]
    can_redirect_to?(*controller_and_action)
  end

  def authorize_user!
    unless can_redirect_to?(controller_name, action_name)
      raise AccessDenied.new("Acess denied to '#{controller_name}##{action_name}'") if current_user
    end
  end

end
