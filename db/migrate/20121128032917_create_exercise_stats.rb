class CreateExerciseStats < ActiveRecord::Migration
  def change
    create_table :exercise_stats do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.decimal :best_weight
      t.integer :best_reps

      t.timestamps
    end
  end
end
