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

ActiveRecord::Schema[7.0].define(version: 2022_10_09_214247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "description"
  end

  create_table "challenges", id: :serial, force: :cascade do |t|
    t.float "points"
    t.integer "max_tries"
    t.string "link"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
    t.boolean "active"
    t.string "flag"
    t.integer "category_id"
    t.string "after_message"
    t.bigint "user_id"
    t.text "setting"
    t.index ["category_id"], name: "index_challenges_on_category_id"
    t.index ["user_id"], name: "index_challenges_on_user_id"
  end

  create_table "ctf_settings", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "value_type"
  end

  create_table "hints", force: :cascade do |t|
    t.bigint "challenge_id"
    t.text "hint_text"
    t.float "penalty", default: 0.0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["challenge_id"], name: "index_hints_on_challenge_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "path"
    t.text "html_content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["path"], name: "index_pages_on_path", unique: true
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.string "browser"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "flag"
    t.bigint "team_id"
    t.bigint "user_id"
    t.string "submission_hash"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "valid_submission"
    t.bigint "category_id"
    t.bigint "challenge_id"
    t.index ["category_id"], name: "index_submissions_on_category_id"
    t.index ["challenge_id"], name: "index_submissions_on_challenge_id"
    t.index ["team_id"], name: "index_submissions_on_team_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "invitation_token"
    t.integer "score", default: 0
    t.datetime "last_valid_submission_at", precision: nil
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "team_id"
    t.boolean "admin"
    t.boolean "organizer"
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.boolean "active"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "challenges", "categories"
  add_foreign_key "challenges", "users"
  add_foreign_key "hints", "challenges"
  add_foreign_key "sessions", "users"
  add_foreign_key "submissions", "categories"
  add_foreign_key "submissions", "challenges"
  add_foreign_key "submissions", "teams"
  add_foreign_key "submissions", "users"
  add_foreign_key "users", "teams"
end
