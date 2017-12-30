class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.string :category
      t.string :currency
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.string :made_on
      t.string :mode
      t.string :status
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
