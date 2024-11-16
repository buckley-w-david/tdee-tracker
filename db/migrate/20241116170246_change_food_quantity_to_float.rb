class ChangeFoodQuantityToFloat < ActiveRecord::Migration[7.2]
  def change
    change_column(:foods, :quantity, :float)
  end
end
