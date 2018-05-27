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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_14_233101) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "capture_the_flags", force: :cascade do |t|
    t.string "name"
    t.string "info"
    t.integer "max_teammates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.float "points"
    t.integer "max_tries"
    t.string "link"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "active"
    t.string "flag"
    t.integer "category_id"
    t.index ["category_id"], name: "index_challenges_on_category_id"
  end

  create_table "ctf_admins", force: :cascade do |t|
    t.integer "users_id"
    t.integer "capture_the_flag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capture_the_flag_id"], name: "index_ctf_admins_on_capture_the_flag_id"
    t.index ["users_id"], name: "index_ctf_admins_on_users_id"
  end

  create_table "ctf_points", force: :cascade do |t|
    t.integer "users_id"
    t.integer "challenges_id"
    t.integer "teams_id"
    t.float "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.integer "user_id"
    t.index ["challenges_id"], name: "index_ctf_points_on_challenges_id"
    t.index ["team_id"], name: "index_ctf_points_on_team_id"
    t.index ["teams_id"], name: "index_ctf_points_on_teams_id"
    t.index ["user_id"], name: "index_ctf_points_on_user_id"
    t.index ["users_id"], name: "index_ctf_points_on_users_id"
  end

  create_table "ctf_settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hints", force: :cascade do |t|
    t.integer "challenges_id"
    t.float "penalty"
    t.string "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenges_id"], name: "index_hints_on_challenges_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.string "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.boolean "admin"
    t.boolean "organizer"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
