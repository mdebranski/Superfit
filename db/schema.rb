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

ActiveRecord::Schema.define(:version => 20120629210839) do

  create_table "exercises", :force => true do |t|
    t.string "name",     :null => false
    t.string "category", :null => false
  end

  create_table "food_entries", :force => true do |t|
    t.string  "user_id", :null => false
    t.string  "food_id", :null => false
    t.integer "amount",  :null => false
    t.string  "units",   :null => false
  end

  create_table "foods", :force => true do |t|
    t.string  "name",             :null => false
    t.string  "category",         :null => false
    t.integer "serving_size",     :null => false
    t.text    "nutritional_info", :null => false
  end

  create_table "strengths", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string "name",        :null => false
    t.string "location"
    t.string "gender"
    t.string "picture"
    t.string "facebook_id"
  end

  create_table "wods", :force => true do |t|
    t.string "name",           :null => false
    t.string "type",           :null => false
    t.string "category",       :null => false
    t.string "scoring_method", :null => false
    t.text   "workout_male"
    t.text   "workout_female"
    t.text   "scoring_notes"
    t.text   "workout_notes"
  end

end
