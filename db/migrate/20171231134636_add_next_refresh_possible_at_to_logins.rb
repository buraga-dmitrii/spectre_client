class AddNextRefreshPossibleAtToLogins < ActiveRecord::Migration[5.1]
  def change
    add_column :logins, :next_refresh_possible_at, :datetime
  end
end
