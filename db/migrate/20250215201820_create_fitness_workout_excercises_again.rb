class CreateFitnessWorkoutExcercisesAgain < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_workout_excercises do |t|
      t.references :workout, null: false, foreign_key: { to_table: :fitness_workouts }
      t.references :excercise, null: false, foreign_key: { to_table: :fitness_excercises }

      t.timestamps
    end
  end
end
