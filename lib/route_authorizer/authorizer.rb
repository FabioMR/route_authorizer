module RouteAuthorizer::Authorizer

  extend ActiveSupport::Concern

  class AccessDenied < StandardError; end

  included do
    helper_method :permit?, :permit_path?
  end

private

  def permission
    @permission ||= ::Permission.new(current_user.try(:role))
  end

  def permit?(_controller_path, _action_name)
    permission.permit?(_controller_path, _action_name)
  end

  def permit_path?(path)
    controller_and_action = Rails.application.routes.recognize_path(path).values[0..1]
    permit?(*controller_and_action)
  end

  def authorize_user!
    unless permit?(controller_path.to_s.gsub(/\//, "_"), action_name)
      raise AccessDenied.new("Acess denied to '#{controller_path}##{action_name}'")
    end
  end

end

ActionController::Base.include(RouteAuthorizer::Authorizer)
