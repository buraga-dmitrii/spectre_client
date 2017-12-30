class SpectreApi
  extend ServiceInitializer

  def self.refresh_logins(current_user)
    customer = current_user.customer
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    response = api.request("GET", "https://www.saltedge.com/api/v3/logins?customer_id=#{customer.customer_id}")
    hash = JSON.parse(response.body)
    customer.logins.delete_all

    hash['data'].each do |login|
      new_login = Login.new
      new_login.login_id = login['id']
      new_login.status = login['status']
      new_login.provider = login['provider_name']
      new_login.customer = current_user.customer
      new_login.save
    end
    customer.reload
  end
 

end
