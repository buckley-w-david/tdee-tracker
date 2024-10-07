class AddGoogleFitAuthorization < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_fit_token, :text, null: true
  end
end
