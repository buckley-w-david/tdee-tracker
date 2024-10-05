class AddFoodReferenceToFoodEntries < ActiveRecord::Migration[7.2]
  def change
    add_reference :food_entries, :food, null: false, foreign_key: true
  end
end
