class CreateWorkoutEntries < ActiveRecord::Migration
  def change
    create_table :workout_entries do |t|
      t.integer :exercise_id
      t.integer :workout_id
      t.timestamps
    end
    add_index :workout_entries, :exercise_id
    add_index :workout_entries, :workout_id
  end
end
