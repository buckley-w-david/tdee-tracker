class AddWithingsTokensToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :withings_access_token, :string
    add_column :users, :withings_refresh_token, :string
    add_column :users, :withings_expires_at, :datetime
  end
end
