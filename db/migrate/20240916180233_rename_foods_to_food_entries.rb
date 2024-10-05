class RenameFoodsToFoodEntries < ActiveRecord::Migration[7.2]
  def change
    rename_table :foods, :food_entries
  end
end
