class AddDayToTotalDailyExpendedEnergies < ActiveRecord::Migration[7.2]
  def change
    add_reference :total_daily_expended_energies, :day, null: true, foreign_key: true
  end
end
