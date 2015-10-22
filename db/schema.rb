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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150425155436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "creator_user_id", null: false
    t.integer  "event_id",        null: false
    t.text     "text",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "comments", ["event_id", "created_at"], name: "index_comments_on_event_id_and_created_at", using: :btree

  create_table "conferences", force: :cascade do |t|
    t.integer  "creator_user_id",   null: false
    t.date     "starting_at",       null: false
    t.date     "ending_at",         null: false
    t.date     "allow_starting_at", null: false
    t.date     "allow_ending_at",   null: false
    t.integer  "year",              null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "timezone",          null: false
  end

  add_index "conferences", ["year"], name: "index_conferences_on_year", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "creator_user_id"
    t.string   "anonymous_user_ip"
    t.string   "name",                                null: false
    t.string   "coordinator"
    t.string   "coordinator_twitter"
    t.string   "url"
    t.string   "location"
    t.text     "description"
    t.datetime "starting_at",                         null: false
    t.datetime "ending_at",                           null: false
    t.boolean  "listed",                              null: false
    t.boolean  "deleted",             default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deleted_by_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "conference_id",                       null: false
    t.integer  "comments_count",      default: 0,     null: false
  end

  add_index "events", ["starting_at"], name: "index_events_on_starting_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "avatar"
    t.string   "provider",                             null: false
    t.string   "uid",                                  null: false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "role",                default: "user", null: false
    t.string   "twitter_handle",      default: ""
    t.boolean  "notify_email",        default: false
    t.boolean  "notify_twitter",      default: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

  add_foreign_key "comments", "events"
  add_foreign_key "comments", "users", column: "creator_user_id"
  add_foreign_key "conferences", "users", column: "creator_user_id"
  add_foreign_key "events", "conferences"
  add_foreign_key "events", "users", column: "creator_user_id"
  add_foreign_key "events", "users", column: "deleted_by_user_id"
end
