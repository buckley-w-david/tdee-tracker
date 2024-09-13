class CreateMeals < ActiveRecord::Migration[7.2]
  def change
    create_table :meals do |t|
      t.references :day, null: false, foreign_key: true
      t.string :name
      t.references :foods, null: false, foreign_key: true

      t.timestamps
    end
  end
end
