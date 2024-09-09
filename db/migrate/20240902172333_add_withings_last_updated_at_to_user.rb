class AddWithingsLastUpdatedAtToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :withings_last_updated_at, :datetime
  end
end
