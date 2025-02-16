class RenameFitnessPlans < ActiveRecord::Migration[7.2]
  def change
    change_table :fitness_sets do |t|
      t.rename :workout_excercise_id, :workout_plan_excercise_id
      t.rename_index :workout_excercise_id, :workout_plan_excercise_id
    end

    rename_table :fitness_sets, :fitness_set_plans

    change_table :fitness_workout_excercises do |t|
      t.rename :workout_id, :workout_plan_id
      t.rename_index :workout_id, :workout_plan_id
    end

    rename_table :fitness_workout_excercises, :fitness_workout_plan_excercises
    rename_table :fitness_workouts, :fitness_workout_plans
  end
end
