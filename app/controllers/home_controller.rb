class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
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
  end

  
end
