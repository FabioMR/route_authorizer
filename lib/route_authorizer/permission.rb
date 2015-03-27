class RouteAuthorizer::Permission

  include RouteAuthorizer::PermissionDSL

  def initialize(role)
    @role = role.to_s
  end

  def permit?(controller_path, action_name)
    permit_action? [
      [:all],
      [controller_path.to_sym, :all],
      [controller_path.to_sym, action_name.to_sym],
    ]
  end

private

  attr_reader :role

  def permit_action?(role_action)
    (role_permissions & role_action).any?
  end

  def role_permissions
    others_permissions = respond_to?(role, true) ? send(role) : []
    default + others_permissions
  end

  def default
    []
  end

end
