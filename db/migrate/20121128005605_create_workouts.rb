class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :id
      t.integer :user_id
      t.string :name
      t.string :note
      t.string :unit

      t.timestamps
    end
    add_index :workouts, :user_id
  end
end
