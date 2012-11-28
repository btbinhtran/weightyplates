class CreateEntryDetails < ActiveRecord::Migration
  def change
    create_table :entry_details do |t|
      t.integer :set_number
      t.integer :reps
      t.decimal :weight

      t.timestamps
    end
  end
end
