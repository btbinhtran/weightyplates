class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :type
      t.string :muscle
      t.string :equipment
      t.string :mechanics
      t.string :force
      t.boolean :is_sport, default: false
      t.string :level

      t.timestamps
    end
  end
end
