class CreateFitnessSets < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_sets do |t|
      t.references :workout_excercise, null: false, foreign_key: { to_table: :fitness_workout_excercises }
      t.integer :reps
      t.integer :weight
      t.integer :duration

      t.timestamps
    end
  end
end
