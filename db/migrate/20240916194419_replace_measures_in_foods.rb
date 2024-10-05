class ReplaceMeasuresInFoods < ActiveRecord::Migration[7.2]
  def change
    remove_column :foods, :measures

    add_column :foods, :quantity, :integer
    add_column :foods, :unit, :string
    add_column :foods, :kilocalories, :integer
  end
end
