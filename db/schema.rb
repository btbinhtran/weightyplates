# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121128032917) do

  create_table "categories", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "entry_details", :force => true do |t|
    t.integer  "workout_entry_id"
    t.integer  "set_number"
    t.integer  "reps"
    t.decimal  "weight"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "entry_details", ["workout_entry_id"], :name => "index_entry_details_on_workout_entry_id"

  create_table "exercise_categories", :force => true do |t|
    t.integer  "exercise_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "exercise_categories", ["category_id"], :name => "index_exercise_categories_on_category_id"
  add_index "exercise_categories", ["exercise_id"], :name => "index_exercise_categories_on_exercise_id"

  create_table "exercise_stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.decimal  "best_weight"
    t.integer  "best_reps"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "exercises", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "default_unit",           :default => "lb"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workout_entries", :force => true do |t|
    t.integer  "exercise_id"
    t.integer  "workout_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "workout_entries", ["exercise_id"], :name => "index_workout_entries_on_exercise_id"
  add_index "workout_entries", ["workout_id"], :name => "index_workout_entries_on_workout_id"

  create_table "workouts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "note"
    t.string   "unit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "workouts", ["user_id"], :name => "index_workouts_on_user_id"

end
