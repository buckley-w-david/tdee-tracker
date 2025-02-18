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

ActiveRecord::Schema[7.2].define(version: 2025_02_18_002638) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "days", force: :cascade do |t|
    t.integer "kilocalories"
    t.float "weight"
    t.date "date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_days_on_user_id"
  end

  create_table "fitness_exercise_tags", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "exercise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_fitness_exercise_tags_on_exercise_id"
    t.index ["tag_id"], name: "index_fitness_exercise_tags_on_tag_id"
  end

  create_table "fitness_exercises", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "demonstration_youtube_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "warmup_strategy"
  end

  create_table "fitness_routines", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "schedule_type"
    t.index ["user_id"], name: "index_fitness_routines_on_user_id"
  end

  create_table "fitness_set_plans", force: :cascade do |t|
    t.integer "workout_plan_exercise_id", null: false
    t.integer "reps"
    t.integer "weight"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_plan_exercise_id"], name: "index_fitness_set_plans_on_workout_plan_exercise_id"
  end

  create_table "fitness_sets", force: :cascade do |t|
    t.integer "workout_exercise_id", null: false
    t.integer "reps"
    t.integer "planned_reps"
    t.integer "weight"
    t.integer "planned_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_exercise_id"], name: "index_fitness_sets_on_workout_exercise_id"
  end

  create_table "fitness_workout_exercises", force: :cascade do |t|
    t.integer "workout_id", null: false
    t.integer "exercise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_fitness_workout_exercises_on_exercise_id"
    t.index ["workout_id"], name: "index_fitness_workout_exercises_on_workout_id"
  end

  create_table "fitness_workout_plan_exercises", force: :cascade do |t|
    t.integer "workout_plan_id", null: false
    t.integer "exercise_id", null: false
    t.integer "weight_progression"
    t.integer "duration_progression"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reps_progression"
    t.index ["exercise_id"], name: "index_fitness_workout_plan_exercises_on_exercise_id"
    t.index ["workout_plan_id"], name: "index_fitness_workout_plan_exercise_on_workout_plan_id"
  end

  create_table "fitness_workout_plans", force: :cascade do |t|
    t.string "name"
    t.integer "routine_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "planned_date"
    t.index ["routine_id"], name: "index_fitness_workout_plans_on_routine_id"
  end

  create_table "fitness_workouts", force: :cascade do |t|
    t.date "date"
    t.integer "workout_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_fitness_workouts_on_user_id"
    t.index ["workout_plan_id"], name: "index_fitness_workouts_on_workout_plan_id"
  end

  create_table "food_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meal_id", null: false
    t.float "quantity"
    t.string "unit"
    t.integer "food_id", null: false
    t.index ["food_id"], name: "index_food_entries_on_food_id"
    t.index ["meal_id"], name: "index_food_entries_on_meal_id"
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
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.integer "day_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_meals_on_day_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "days", "users"
  add_foreign_key "fitness_exercise_tags", "fitness_exercises", column: "exercise_id"
  add_foreign_key "fitness_exercise_tags", "tags"
  add_foreign_key "fitness_routines", "users"
  add_foreign_key "fitness_set_plans", "fitness_workout_plan_exercises", column: "workout_plan_exercise_id"
  add_foreign_key "fitness_sets", "fitness_workout_exercises", column: "workout_exercise_id"
  add_foreign_key "fitness_workout_exercises", "fitness_exercises", column: "exercise_id"
  add_foreign_key "fitness_workout_exercises", "fitness_workouts", column: "workout_id"
  add_foreign_key "fitness_workout_plan_exercises", "fitness_exercises", column: "exercise_id"
  add_foreign_key "fitness_workout_plan_exercises", "fitness_workout_plans", column: "workout_plan_id"
  add_foreign_key "fitness_workout_plans", "fitness_routines", column: "routine_id"
  add_foreign_key "fitness_workouts", "fitness_workout_plans", column: "workout_plan_id"
  add_foreign_key "fitness_workouts", "users"
  add_foreign_key "food_entries", "foods"
  add_foreign_key "food_entries", "meals"
  add_foreign_key "goals", "users"
  add_foreign_key "meals", "days"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
