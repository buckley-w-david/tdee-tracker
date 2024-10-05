class AddQuantityAndUnitToFoodEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :food_entries, :quantity, :float
    add_column :food_entries, :unit, :string
  end
end
