json.extract! account, :id, :account_id, :name, :balance, :currency, :nature, :login_id, :created_at, :updated_at
json.url account_url(account, format: :json)
