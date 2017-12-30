class ApplicationController < ActionController::Base
  CLIENT_ID =  Rails.application.secrets.client_id        
  SERVICE_SECRET = Rails.application.secrets.service_secret
  protect_from_forgery with: :exception
end
