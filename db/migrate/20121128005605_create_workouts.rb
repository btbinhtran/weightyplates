class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :id
      t.string :name
      t.string :note
      t.string :unit

      t.timestamps
    end
  end
end
