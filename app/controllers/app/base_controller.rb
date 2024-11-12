# app/controllers/app/base_controller.rb
module App
  class BaseController < ApplicationController
    # All controllers in the app namespace require authentication by default
    # Authentication is already included from ApplicationController
  end
end
