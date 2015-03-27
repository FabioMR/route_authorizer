# RouteAuthorizer

Simple routes authorization solution for Rails based on user roles. All permissions are defined in a single location (the Permission class) and not duplicated across your code.

## Installation

Add in your Gemfile:

    gem 'route_authorizer'

And then execute:

    $ bundle

Create Permission file `app/models/permission.rb`:

    rails g route_authorizer:install

## Usage

RouteAuthorizer expects a `current_user` method to exist in the controller. The `current_user` needs a `role` method.

### 1. Checking permissions

Add in your ApplicationController.rb

    before_action :authorize_user!

### 2. Defining permissions

All permissions are defined at Permission file `app/models/permission.rb`.

To permit all roles to HomeController

    all_roles do
      permit :home
    end

Or to a specific action

    all_roles do
      permit :home, only: [:index]
    end

To permit admin (user with admin role) to do all functions

    role :admin do
      permit_all
    end

To permit customer (user with customer role) just to OrdersController

    role :customer do
      permit :orders
    end

You can find a Permission sample [here](https://github.com/FabioMR/route_authorizer/blob/master/samples/permission.rb).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
