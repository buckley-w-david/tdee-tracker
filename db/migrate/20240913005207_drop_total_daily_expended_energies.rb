class DropTotalDailyExpendedEnergies < ActiveRecord::Migration[7.2]
  def change
    drop_table :total_daily_expended_energies
  end
end
