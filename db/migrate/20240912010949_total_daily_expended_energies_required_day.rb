class TotalDailyExpendedEnergiesRequiredDay < ActiveRecord::Migration[7.2]
  def change
    change_column_null :total_daily_expended_energies, :day_id, false
  end
end
