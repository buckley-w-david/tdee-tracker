class CreateFitnessExcercises < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_excercises do |t|
      t.string :name
      t.text :description
      t.text :demonstration_youtube_url

      t.timestamps
    end
  end
end
