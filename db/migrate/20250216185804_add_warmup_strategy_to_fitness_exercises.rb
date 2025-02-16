class AddWarmupStrategyToFitnessExercises < ActiveRecord::Migration[7.2]
  def change
    add_column :fitness_exercises, :warmup_strategy, :string
  end
end
