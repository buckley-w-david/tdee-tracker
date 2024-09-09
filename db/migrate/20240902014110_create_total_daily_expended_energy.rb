class CreateTotalDailyExpendedEnergy < ActiveRecord::Migration[7.2]
  def change
    create_table :total_daily_expended_energies do |t|
      t.integer :tdee, null: false
      t.integer :span, null: false
      t.date :date, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
