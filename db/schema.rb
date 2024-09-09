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

ActiveRecord::Schema[7.2].define(version: 2024_09_02_172333) do
  create_table "entries", force: :cascade do |t|
    t.integer "kilocalories"
    t.float "weight"
    t.date "date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "total_daily_expended_energies", force: :cascade do |t|
    t.integer "tdee", null: false
    t.integer "span", null: false
    t.date "date", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_total_daily_expended_energies_on_user_id"
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
  end

  add_foreign_key "entries", "users"
  add_foreign_key "total_daily_expended_energies", "users"
end
