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

ActiveRecord::Schema[7.2].define(version: 2024_10_01_182049) do
  create_table "case_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "color"
    t.integer "next_step_id"
    t.boolean "case_ends_here"
    t.boolean "enabled"
    t.boolean "case_begins_here"
    t.index ["next_step_id"], name: "index_case_statuses_on_next_step_id"
  end

  create_table "case_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prefix"
    t.string "title"
    t.boolean "enabled"
  end

  create_table "cases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "case_type_id"
    t.integer "case_status_id"
    t.string "case_no"
    t.string "title"
    t.text "summary"
    t.string "local_records"
    t.integer "manager_id"
    t.index ["case_status_id"], name: "index_cases_on_case_status_id"
    t.index ["case_type_id"], name: "index_cases_on_case_type_id"
    t.index ["manager_id"], name: "index_cases_on_manager_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "case_statuses", "case_statuses", column: "next_step_id"
  add_foreign_key "cases", "users", column: "manager_id"
end
