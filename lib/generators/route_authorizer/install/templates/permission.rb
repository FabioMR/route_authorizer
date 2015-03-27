class Permission < RouteAuthorizer::Permission

  # Users can access all actions of HomeController
  # all_roles do
  #   permit :home
  # end

  # Admin can access all controllers and actions
  # role :admin do
  #   permit_all
  # end

  # Staff can access all actions of ProductsController
  # role :staff do
  #   permit :products
  # end

  # Customer can access all actions of OrdersController and just actions Index and Show of ProductsController
  # role :customer do
  #   permit :orders
  #   permit :products, only: [:index, :show]
  # end

end
