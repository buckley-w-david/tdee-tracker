class CreateFitnessWorkoutsAgain < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_workouts do |t|
      t.date :date
      t.references :workout_plan, null: false, foreign_key: { to_table: :fitness_workout_plans }

      t.timestamps
    end
  end
end
