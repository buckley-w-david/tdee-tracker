class AddRepsProgressionToFitnessWorkoutPlanExercise < ActiveRecord::Migration[7.2]
  def change
    add_column :fitness_workout_plan_exercises, :reps_progression, :integer
  end
end
