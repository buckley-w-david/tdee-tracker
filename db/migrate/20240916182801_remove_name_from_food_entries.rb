class RemoveNameFromFoodEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :food_entries, :name, :string
  end
end
