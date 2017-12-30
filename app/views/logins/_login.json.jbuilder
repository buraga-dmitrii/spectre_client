json.extract! login, :id, :login_id, :hashid, :status, :provider, :customer_id, :created_at, :updated_at
json.url login_url(login, format: :json)
