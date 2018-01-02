class ApplicationController < ActionController::Base
  CLIENT_ID =  Rails.application.secrets.client_id        
  SERVICE_SECRET = Rails.application.secrets.service_secret
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    unless current_user.customer
      api = Saltedge.new(CLIENT_ID, SERVICE_SECRET)
      response = api.request("POST", "https://www.saltedge.com/api/v3/customers/", {"data" => {"identifier" => current_user.email}})
      hash = JSON.parse(response.body)
      customer = Customer.new
      customer.customer_id = hash['data']['id']
      customer.identifier = hash['data']['identifier']
      customer.secret = hash['data']['secret']
      customer.user = current_user
      customer.save
    end
        
    logins_path
  end


end
