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

ActiveRecord::Schema.define(version: 20180412224342) do

  create_table "capture_the_flags", force: :cascade do |t|
    t.string   "name"
    t.string   "info"
    t.integer  "max_teammates"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "challenge_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.float    "points"
    t.integer  "max_tries"
    t.string   "link"
    t.text     "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "challenge_category_id"
    t.index ["challenge_category_id"], name: "index_challenges_on_challenge_category_id"
  end

  create_table "ctf_admins", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "capture_the_flag_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["capture_the_flag_id"], name: "index_ctf_admins_on_capture_the_flag_id"
    t.index ["users_id"], name: "index_ctf_admins_on_users_id"
  end

  create_table "ctf_points", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "challenges_id"
    t.integer  "teams_id"
    t.float    "points"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["challenges_id"], name: "index_ctf_points_on_challenges_id"
    t.index ["teams_id"], name: "index_ctf_points_on_teams_id"
    t.index ["users_id"], name: "index_ctf_points_on_users_id"
  end

  create_table "ctf_settings", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hints", force: :cascade do |t|
    t.integer  "challenges_id"
    t.float    "penalty"
    t.string   "description"
    t.string   "link"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["challenges_id"], name: "index_hints_on_challenges_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.integer  "User_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["User_id"], name: "index_organizers_on_User_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer  "teams_id"
    t.integer  "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teams_id"], name: "index_team_members_on_teams_id"
    t.index ["users_id"], name: "index_team_members_on_users_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "invitation_token"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "team_id"
    t.boolean  "admin"
    t.boolean  "organizer"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
