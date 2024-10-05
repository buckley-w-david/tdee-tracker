class CreateFoodsForReal < ActiveRecord::Migration[7.2]
  def change
    create_table :foods do |t|
      t.string :name
      t.json :measures

      t.timestamps
    end
  end
end
