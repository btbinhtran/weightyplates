class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :id
      t.integer :user_id
      t.string :name, :null => false
      t.string :note
      t.string :unit, :null => false

      t.timestamps
    end
    add_index :workouts, :user_id
  end
end
