class RemoveTotalDailyExpendedEnergyFromDays < ActiveRecord::Migration[7.2]
  def change
    remove_column :days, :total_daily_expended_energy
  end
end
