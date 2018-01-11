require "#{Rails.root}/lib/saltedge"
class ApplicationController < ActionController::Base

  CLIENT_ID =  Rails.application.secrets.client_id        
  SERVICE_SECRET = Rails.application.secrets.service_secret
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    unless current_user.customer
      SpectreApi.create_customer(current_user) 
    end
    logins_path
  end


end
