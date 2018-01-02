json.extract! transaction, :id, :transaction_id, :category, :currency, :amount, :description, :made_on, :mode, :status, :account_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
