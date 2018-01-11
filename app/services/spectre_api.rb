require "#{Rails.root}/lib/saltedge"
class SpectreApi
  BASE_URL = 'https://www.saltedge.com/api/v3'.freeze

  def self.create_customer(current_user)
    response = request('POST',
                       "#{BASE_URL}/customers/",
                       'data' =>
                          { 'identifier' => current_user.email })
    customer = Customer.new
    customer.customer_id = response['data']['id']
    customer.identifier  = response['data']['identifier']
    customer.secret      = response['data']['secret']
    customer.user        = current_user
    customer.save
  end

  def self.create_login(customer_id, logins_url)
    response = request('POST',
                       "#{BASE_URL}/tokens/create",
                       'data' =>
                          { 'customer_id' => customer_id,
                            'fetch_type' => 'recent',
                            'return_to' => "#{logins_url}?refresh=true" })
    response['data']['connect_url']
  end

  def self.refresh_login(login, logins_url)
    response = request('POST',
                       "#{BASE_URL}/tokens/refresh",
                       'data' =>
                          { 'login_id' => login.login_id,
                            'fetch_type' => 'recent',
                            'return_to' => logins_url.to_s })
    response['data']['connect_url']
  end

  def self.destroy_login(login)
    response = request('DELETE',
                       "#{BASE_URL}/logins/#{login.login_id}")
  end

  def self.reconnect_login(login, logins_url)
    response = request('POST',
                       "#{BASE_URL}/tokens/reconnect",
                       'data' =>
                          { 'login_id' => login.login_id,
                            'fetch_type' => 'recent',
                            'return_to' => "#{logins_url}?refresh=true" })
    response['data']['connect_url']
  end

  def self.update_logins(current_user)
    customer = current_user.customer
    response = request('GET', "#{BASE_URL}/logins?customer_id=#{customer.customer_id}")
    customer.logins.destroy_all

    response['data'].each do |login|
      new_login = Login.new
      new_login.login_id = login['id']
      new_login.status   = login['status'] || ''
      new_login.provider = login['provider_name'] || ''
      new_login.next_refresh_possible_at = login['next_refresh_possible_at'] || ''
      new_login.customer = current_user.customer
      new_login.save

      SpectreApi.update_accounts(new_login)
    end
    customer.reload
  end

  def self.update_accounts(login)
    response = request('GET', "#{BASE_URL}/accounts?login_id=#{login.login_id}")
    login.accounts.destroy_all

    response['data'].each do |account|
      new_account = Account.new
      new_account.account_id = account['id']
      new_account.currency   = account['currency_code'] || ''
      new_account.balance    = account['balance'] || ''
      new_account.name       = account['name'] || ''
      new_account.nature     = account['nature'] || ''
      new_account.login      = login
      new_account.save

      SpectreApi.update_transactions(new_account)
    end
  end

  def self.update_transactions(account)
    response = request('GET', "#{BASE_URL}/transactions?account_id=#{account.account_id}")
    account.transactions.delete_all

    response['data'].each do |transaction|
      new_transaction = Transaction.new
      new_transaction.transaction_id = transaction['id']
      new_transaction.currency       = transaction['currency_code'] || ''
      new_transaction.category       = transaction['category'] || ''
      new_transaction.amount         = transaction['amount'] || ''
      new_transaction.description    = transaction['description'] || ''
      new_transaction.made_on        = transaction['made_on'] || ''
      new_transaction.mode           = transaction['mode'] || ''
      new_transaction.status         = transaction['status'] || ''
      new_transaction.account        = account
      new_transaction.save
    end
  end

  private

  def self.request(method, url, data = {})
    api = Saltedge.new(Rails.application.secrets.client_id,
                       Rails.application.secrets.service_secret)
    response = api.request(method, url, data)
    JSON.parse(response.body)
  end
end
