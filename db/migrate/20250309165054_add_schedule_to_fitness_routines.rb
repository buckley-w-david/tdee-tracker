class AddScheduleToFitnessRoutines < ActiveRecord::Migration[7.2]
  def change
    add_column :fitness_routines, :schedule, :text, default: '["monday", "wednesday", "friday"]'
    remove_column :fitness_routines, :schedule_type, :string
  end
end
