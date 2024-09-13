class RenameEntriesToDays < ActiveRecord::Migration[7.2]
  def change
    rename_table :entries, :days
  end
end
