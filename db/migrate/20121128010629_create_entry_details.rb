class CreateEntryDetails < ActiveRecord::Migration
  def change
    create_table :entry_details do |t|
      t.integer :workout_entry_id
      t.integer :set_number, :null => false
      t.integer :reps, :null => false
      t.decimal :weight, :null => false

      t.timestamps
    end

    add_index :entry_details, :workout_entry_id
  end
end
