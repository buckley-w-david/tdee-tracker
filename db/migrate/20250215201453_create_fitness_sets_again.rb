class CreateFitnessSetsAgain < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_sets do |t|
      t.references :workout_excercise, null: false, foreign_key: { to_table: :fitness_workout_excercises }

      t.integer :reps
      t.integer :planned_reps

      t.integer :weight
      t.integer :planned_weight

      t.timestamps
    end
  end
end
