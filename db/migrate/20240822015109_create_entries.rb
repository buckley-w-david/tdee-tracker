class CreateEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :entries do |t|
      t.integer :kilocalories
      t.float :weight
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
