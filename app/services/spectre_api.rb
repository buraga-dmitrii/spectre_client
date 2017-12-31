class SpectreApi
  extend ServiceInitializer

  def self.create_login(customer_id, logins_url)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
      response = api.request("POST", "https://www.saltedge.com/api/v3/tokens/create", {"data" => {"customer_id" => customer_id, "fetch_type" => "recent", "return_to" => "#{logins_url}?refresh=true"}})
      hash = JSON.parse(response.body)
      hash['data']['connect_url']
  end

  def self.refresh_login(login, logins_url)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    response = api.request("POST", "https://www.saltedge.com/api/v3/tokens/refresh", {"data" => {"login_id" => login.login_id, "fetch_type" => "recent", "return_to" => "#{logins_url}?refresh=true"}})
    hash = JSON.parse(response.body)
    hash['data']['connect_url']
    # api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    # response = api.request("PUT", "https://www.saltedge.com/api/v3/logins/#{login.login_id}/refresh", {  "data" => {   "fetch_type" => "recent" }})
    # hash = JSON.parse(response.body)
    # login_hash     = hash['data']
    # login.login_id = login_hash['id']
    # login.status   = login_hash['status']
    # login.next_refresh_possible_at = login_hash['next_refresh_possible_at']
    # login.provider = login_hash['provider_name']
    # login.save

    # SpectreApi.update_accounts(login)
  end

  def self.destroy_login(login)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    response = api.request("DELETE", "https://www.saltedge.com/api/v3/logins/#{login.login_id}")
  end

  def self.reconnect_login(login, logins_url)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
      response = api.request("POST", "https://www.saltedge.com/api/v3/tokens/reconnect", {"data" => {"login_id" => login.login_id, "fetch_type" => "recent", "return_to" => "#{logins_url}?refresh=true"}})
      hash = JSON.parse(response.body)
      hash['data']['connect_url']
  end    

  def self.update_logins(current_user)
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
      new_login.next_refresh_possible_at = login['next_refresh_possible_at']
      new_login.customer = current_user.customer
      new_login.save

      SpectreApi.update_accounts(new_login)
    end
    customer.reload
  end
 
  def self.update_accounts(login)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    response = api.request("GET", "https://www.saltedge.com/api/v3/accounts?login_id=#{login.login_id}")
    hash = JSON.parse(response.body)
    login.accounts.destroy_all

    hash['data'].each do |account|
      new_account = Account.new
      new_account.account_id = account['id']
      new_account.currency = account['currency_code']
      new_account.balance = account['balance']
      new_account.name = account['name']
      new_account.nature = account['nature']
      new_account.login = login
      new_account.save

      SpectreApi.update_transactions(new_account)
    end

  end

  def self.update_transactions(account)
    api = Saltedge.new(Rails.application.secrets.client_id, Rails.application.secrets.service_secret)
    response = api.request("GET", "https://www.saltedge.com/api/v3/transactions?account_id=#{account.account_id}")
    hash = JSON.parse(response.body)
    account.transactions.delete_all

    hash['data'].each do |transaction|
      new_transaction = Transaction.new
      new_transaction.transaction_id = transaction['id']
      new_transaction.currency = transaction['currency_code']
      new_transaction.category = transaction['category']
      new_transaction.amount = transaction['amount']
      new_transaction.description = transaction['description']
      new_transaction.made_on = transaction['made_on']
      new_transaction.mode = transaction['mode']
      new_transaction.status = transaction['status']
      new_transaction.account = account
      new_transaction.save
    end
  end  
end
