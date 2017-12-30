class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.integer :customer_id
      t.string :identifier
      t.string :secret
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
