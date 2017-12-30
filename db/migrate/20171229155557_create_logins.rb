class CreateLogins < ActiveRecord::Migration[5.1]
  def change
    create_table :logins do |t|
      t.integer :login_id
      t.string :hashid
      t.string :status
      t.string :provider
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
