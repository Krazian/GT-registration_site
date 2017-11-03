module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_administrator!
    layout 'admin'

    def after_sign_in_path_for(resource)
      api_settings_path
    end
  end
end