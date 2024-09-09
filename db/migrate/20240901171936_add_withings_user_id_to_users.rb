class AddWithingsUserIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :withings_user_id, :string
  end
end
