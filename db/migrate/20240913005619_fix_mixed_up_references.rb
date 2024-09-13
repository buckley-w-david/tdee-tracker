class FixMixedUpReferences < ActiveRecord::Migration[7.2]
  def change
    remove_column :meals, :foods_id
    change_table :foods do |t|
      t.references :meals, null: false, foreign_key: true
    end
  end
end
