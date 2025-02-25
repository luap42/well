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

ActiveRecord::Schema[7.2].define(version: 2025_01_28_124546) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "calendar_events", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.string "title"
    t.date "when"
    t.boolean "is_deleted"
    t.time "which_time"
    t.index ["case_id"], name: "index_calendar_events_on_case_id"
  end

  create_table "case_permission_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "case_read"
    t.boolean "case_write"
    t.boolean "participants_read"
    t.boolean "participants_write"
    t.boolean "calendar_read"
    t.boolean "calendar_write"
    t.boolean "documents_read"
    t.boolean "documents_write"
    t.boolean "notes_read"
    t.boolean "notes_write"
    t.boolean "tasks_read"
    t.boolean "tasks_write"
    t.boolean "representments_access"
    t.boolean "writings_access"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "time_record_access"
  end

  create_table "case_permissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "user_id"
    t.bigint "case_permission_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_case_permissions_on_case_id"
    t.index ["case_permission_type_id"], name: "index_case_permissions_on_case_permission_type_id"
    t.index ["user_id"], name: "index_case_permissions_on_user_id"
  end

  create_table "case_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "color"
    t.bigint "next_step_id"
    t.boolean "case_ends_here"
    t.boolean "enabled"
    t.boolean "case_begins_here"
    t.index ["next_step_id"], name: "index_case_statuses_on_next_step_id"
  end

  create_table "case_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prefix"
    t.string "title"
    t.boolean "enabled"
  end

  create_table "cases", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_type_id"
    t.bigint "case_status_id"
    t.string "case_no"
    t.string "title"
    t.text "summary"
    t.string "local_records"
    t.bigint "manager_id"
    t.boolean "is_canonical"
    t.string "pre_canonical_no"
    t.index ["case_status_id"], name: "index_cases_on_case_status_id"
    t.index ["case_type_id"], name: "index_cases_on_case_type_id"
    t.index ["manager_id"], name: "index_cases_on_manager_id"
  end

  create_table "document_items", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "folder_id"
    t.bigint "document_id"
    t.string "file_name"
    t.boolean "is_primary"
    t.boolean "is_attachment"
    t.boolean "is_transactional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_document_items_on_case_id"
    t.index ["document_id"], name: "index_document_items_on_document_id"
    t.index ["folder_id"], name: "index_document_items_on_folder_id"
  end

  create_table "document_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.boolean "is_enabled"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.bigint "folder_id"
    t.bigint "document_type_id"
    t.bigint "user_id"
    t.bigint "participant_id"
    t.bigint "note_id"
    t.string "name"
    t.boolean "is_deleted"
    t.date "sent_at"
    t.index ["case_id"], name: "index_documents_on_case_id"
    t.index ["document_type_id"], name: "index_documents_on_document_type_id"
    t.index ["folder_id"], name: "index_documents_on_folder_id"
    t.index ["note_id"], name: "index_documents_on_note_id"
    t.index ["participant_id"], name: "index_documents_on_participant_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "folders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.string "name"
    t.string "password"
    t.boolean "is_protected"
    t.boolean "is_default"
    t.index ["case_id"], name: "index_folders_on_case_id"
  end

  create_table "linked_cases", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "target_case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_linked_cases_on_case_id"
    t.index ["target_case_id"], name: "index_linked_cases_on_target_case_id"
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.bigint "user_id"
    t.string "title"
    t.boolean "is_deleted"
    t.index ["case_id"], name: "index_notes_on_case_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "participant_roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "enabled"
  end

  create_table "participants", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.bigint "participant_role_id"
    t.string "name"
    t.text "address_field"
    t.text "contact_details"
    t.string "email"
    t.string "tel_no"
    t.string "mobile_no"
    t.string "fax_no"
    t.text "comment"
    t.boolean "outdated"
    t.boolean "provide_as_template"
    t.boolean "is_deleted"
    t.index ["case_id"], name: "index_participants_on_case_id"
    t.index ["participant_role_id"], name: "index_participants_on_participant_role_id"
  end

  create_table "pinned_cases", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_pinned_cases_on_case_id"
    t.index ["user_id"], name: "index_pinned_cases_on_user_id"
  end

  create_table "representments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "case_id"
    t.date "when"
    t.string "reason"
    t.bigint "to_user_id"
    t.bigint "from_user_id"
    t.boolean "priority"
    t.boolean "dismissed"
    t.index ["case_id"], name: "index_representments_on_case_id"
    t.index ["from_user_id"], name: "index_representments_on_from_user_id"
    t.index ["to_user_id"], name: "index_representments_on_to_user_id"
  end

  create_table "task_columns", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.string "title"
    t.string "default_token"
    t.boolean "is_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_task_columns_on_case_id"
  end

  create_table "task_resolution_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.boolean "is_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "task_column_id"
    t.bigint "user_id"
    t.string "title"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due"
    t.boolean "is_resolved"
    t.bigint "task_resolution_type_id"
    t.index ["case_id"], name: "index_tasks_on_case_id"
    t.index ["task_column_id"], name: "index_tasks_on_task_column_id"
    t.index ["task_resolution_type_id"], name: "index_tasks_on_task_resolution_type_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "time_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "user_id"
    t.string "comment"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.boolean "running"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_time_records_on_case_id"
    t.index ["user_id"], name: "index_time_records_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "shortcode"
    t.integer "time_billing_factor_in_ct"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "writing_cosignatures", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "writing_draft_id"
    t.string "request"
    t.text "response"
    t.boolean "is_pending"
    t.boolean "is_obsoleted"
    t.boolean "is_given"
    t.date "given_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["user_id"], name: "index_writing_cosignatures_on_user_id"
    t.index ["writing_draft_id"], name: "index_writing_cosignatures_on_writing_draft_id"
  end

  create_table "writing_drafts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "case_id"
    t.bigint "user_id"
    t.bigint "participant_id"
    t.bigint "document_item_id"
    t.bigint "writing_type_id"
    t.string "title"
    t.date "writing_date"
    t.boolean "is_final"
    t.boolean "is_confirmed"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_writing_drafts_on_case_id"
    t.index ["document_item_id"], name: "index_writing_drafts_on_document_item_id"
    t.index ["participant_id"], name: "index_writing_drafts_on_participant_id"
    t.index ["user_id"], name: "index_writing_drafts_on_user_id"
    t.index ["writing_type_id"], name: "index_writing_drafts_on_writing_type_id"
  end

  create_table "writing_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "default_token"
    t.boolean "has_recipient"
    t.boolean "has_cosigning_required"
    t.boolean "is_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_writing_types_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_statuses", "case_statuses", column: "next_step_id"
  add_foreign_key "cases", "users", column: "manager_id"
  add_foreign_key "linked_cases", "cases", column: "target_case_id"
  add_foreign_key "representments", "users", column: "from_user_id"
  add_foreign_key "representments", "users", column: "to_user_id"
end
