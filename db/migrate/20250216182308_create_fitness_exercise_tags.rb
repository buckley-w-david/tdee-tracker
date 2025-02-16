class CreateFitnessExerciseTags < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_exercise_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: { to_table: :fitness_exercises }

      t.timestamps
    end
  end
end
