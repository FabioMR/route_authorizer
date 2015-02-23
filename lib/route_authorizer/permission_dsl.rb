module RouteAuthorizer::PermissionDSL

  extend ActiveSupport::Concern

  class_methods do
    def all_roles(&block)
      role(:default, &block)
    end

    def role(name, &block)
      define_method name do
        @current_role = "@#{name}"

        instance_variable_set @current_role, []
        instance_eval &block
        instance_variable_get @current_role
      end
    end
  end

  def permit_all
    instance_variable_get(@current_role) << [:all]
  end

  def permit(controller, options = {})
    actions = options[:only] || [:all]

    actions.each do |action|
      instance_variable_get(@current_role) << [controller, action]
    end
  end

end
