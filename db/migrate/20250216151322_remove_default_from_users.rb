class RemoveDefaultFromUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :fitness_workouts, :user_id, from: 4, to: nil
  end
end
