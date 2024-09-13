class AddTdeeToDay < ActiveRecord::Migration[7.2]
  def change
    add_column :days, :total_daily_expended_energy, :integer
  end
end
