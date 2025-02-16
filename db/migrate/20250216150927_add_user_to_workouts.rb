class AddUserToWorkouts < ActiveRecord::Migration[7.2]
  def change
    add_reference :fitness_workouts, :user, null: false, foreign_key: true, default: 4
  end
end
