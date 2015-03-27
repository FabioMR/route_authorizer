class RouteAuthorizer::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_permission
    copy_file "permission.rb", "app/models/permission.rb"
  end
end
