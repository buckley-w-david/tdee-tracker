class AddPlannedDateToFitnessWorkoutPlans < ActiveRecord::Migration[7.2]
  def change
    add_column :fitness_workout_plans, :planned_date, :date
  end
end
