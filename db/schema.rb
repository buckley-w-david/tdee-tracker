# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_16_171322) do
  create_table "days", force: :cascade do |t|
    t.integer "kilocalories"
    t.float "weight"
    t.date "date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_daily_expended_energy"
    t.index [ "user_id" ], name: "index_days_on_user_id"
  end

  create_table "food_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meal_id", null: false
    t.float "quantity"
    t.string "unit"
    t.integer "food_id", null: false
    t.index [ "food_id" ], name: "index_food_entries_on_food_id"
    t.index [ "meal_id" ], name: "index_food_entries_on_meal_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "quantity"
    t.string "unit"
    t.float "kilocalories"
  end

  create_table "goals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.float "change_per_week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "user_id" ], name: "index_goals_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.integer "day_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "day_id" ], name: "index_meals_on_day_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "withings_access_token"
    t.string "withings_refresh_token"
    t.datetime "withings_expires_at"
    t.string "withings_user_id"
    t.datetime "withings_last_updated_at"
    t.text "google_fit_token"
  end

  add_foreign_key "days", "users"
  add_foreign_key "food_entries", "foods"
  add_foreign_key "food_entries", "meals"
  add_foreign_key "goals", "users"
  add_foreign_key "meals", "days"
end
