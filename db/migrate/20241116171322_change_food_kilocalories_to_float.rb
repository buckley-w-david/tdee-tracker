class ChangeFoodKilocaloriesToFloat < ActiveRecord::Migration[7.2]
  def change
    change_column(:foods, :kilocalories, :float)
  end
end
