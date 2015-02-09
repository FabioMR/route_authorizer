module RouteAuthorizer::Permission

  def initialize(role)
    @role = role.to_s
  end

  def redirect_to?(controller_name, action_name)
    redirect_to_action? [
      [:all],
      [controller_name.to_sym, :all],
      [controller_name.to_sym, action_name.to_sym],
    ]
  end

private

  attr_reader :role

  def redirect_to_action?(role_action)
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
