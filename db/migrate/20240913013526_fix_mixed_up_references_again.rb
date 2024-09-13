class FixMixedUpReferencesAgain < ActiveRecord::Migration[7.2]
  def change
    change_table :foods do |t|
      t.rename :meals_id, :meal_id
    end
  end
end
