require 'roda'
require 'sequel'
require 'wedge'
require 'shield'
require_relative 'app/lib/env'

class TestApp < Roda
  include Shield::Helpers
  use Rack::Session::Cookie, :secret => "mysecret"

  plugin :environments
  plugin :multi_route
  plugin :empty_root
  plugin :rest_api

  def current_user
    authenticated(User)
  end

  configure :development do
    require 'pry'
    require 'awesome_print'
  end

  plugin :wedge,
    scope: self,
    skip_call_middleware: true,
    assets_url: "/assets/wedge/wedge",
    plugins: [:form],
    gzip_assets: true

  plugin :sprocket_assets,
    root:        Dir.pwd,
    public_path: "#{Dir.pwd}/public",
    prefix:      %w`app/ app/assets public/assets bower_components/`,
    debug:       development?,
    opal:        true

  configure :development do
    require 'better_errors'

    # Include middlware
    use BetterErrors::Middleware

    # Show better errors for any ip
    BetterErrors::Middleware.allow_ip! "0.0.0.0/0"
  end

  route do |r|
    # Load the todo app
    r.root do
      r.redirect "/login" if !current_user
      wedge(:todo).to_js :display
    end

    r.api do
      r.resource :users do |users|
        users.list do
          User.all.map do |user|
            {
              id: user.id,
              username: user.username,
              phone_number: user.phone_number,
              email: user.email,
              task_count: user.task_count
            }
          end
        end
        users.one do |params|
          user = User[params[:id]]
          {
            id: user.id,
            username: user.username,
            phone_number: user.phone_number,
            email: user.email,
            task_count: user.task_count,
            tasks: user.tasks_dataset.all
          }
        end
        users.routes :index, :show
      end
    end
    # Handles wedge calls
    r.wedge_assets
    # Handles all assets
    r.sprocket_assets
    # https://github.com/jeremyevans/roda/blob/master/lib/roda/plugins/multi_route.rb
    r.multi_route
  end
end

# Path to project folders
GLOB = "**/{lib,config,routes,models,forms,components}/*.rb"

# Load folders
Dir[GLOB].each { |file| require_relative file }
