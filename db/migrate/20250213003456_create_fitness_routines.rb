class CreateFitnessRoutines < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_routines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
