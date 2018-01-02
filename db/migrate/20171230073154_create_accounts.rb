class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :account_id
      t.string :name
      t.decimal :balance, precision: 10, scale: 2
      t.string :currency
      t.string :nature
      t.references :login, foreign_key: true

      t.timestamps
    end
  end
end
