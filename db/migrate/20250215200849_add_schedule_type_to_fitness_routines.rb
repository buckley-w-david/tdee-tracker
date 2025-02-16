class AddScheduleTypeToFitnessRoutines < ActiveRecord::Migration[7.2]
  def change
    add_column :fitness_routines, :schedule_type, :string
  end
end
