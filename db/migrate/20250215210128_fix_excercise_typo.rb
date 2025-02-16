class FixExcerciseTypo < ActiveRecord::Migration[7.2]
  def change
    rename_table :fitness_excercises, :fitness_exercises

    change_table :fitness_set_plans do |t|
      t.rename :workout_plan_excercise_id, :workout_plan_exercise_id
      t.rename_index :index_fitness_set_plans_on_workout_plan_excercise_id, :index_fitness_set_plans_on_workout_plan_exercise_id
    end

    change_table :fitness_sets do |t|
      t.rename :workout_excercise_id, :workout_exercise_id
      t.rename_index :index_fitness_sets_on_workout_excercise_id, :index_fitness_sets_on_workout_exercise_id
    end

    change_table :fitness_workout_excercises do |t|
      t.rename :excercise_id, :exercise_id
      t.rename_index :index_fitness_workout_excercises_on_excercise_id, :index_fitness_workout_exercise_on_exercise_id
    end

    rename_table :fitness_workout_excercises, :fitness_workout_exercises

    change_table :fitness_workout_plan_excercises do |t|
      t.rename :excercise_id, :exercise_id
      t.rename_index :index_fitness_workout_plan_excercises_on_excercise_id, :index_fitness_workout_plan_exercise_on_exercise_id
      t.rename_index :index_fitness_workout_plan_excercises_on_workout_plan_id, :index_fitness_workout_plan_exercise_on_workout_plan_id
    end

    rename_table :fitness_workout_plan_excercises, :fitness_workout_plan_exercises
  end
end
