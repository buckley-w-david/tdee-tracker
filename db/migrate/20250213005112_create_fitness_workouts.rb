class CreateFitnessWorkouts < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_workouts do |t|
      t.string :name
      t.references :routine, null: false, foreign_key: { to_table: :fitness_routines }

      t.timestamps
    end
  end
end
