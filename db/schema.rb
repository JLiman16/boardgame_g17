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

ActiveRecord::Schema.define(version: 20151120021559) do

  create_table "bgg_accounts", force: :cascade do |t|
    t.string   "account_name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "game_id"
  end

  add_index "bgg_accounts", ["user_id"], name: "index_bgg_accounts_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "boardgamecategory"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "categories_games", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "game_id"
  end

  add_index "categories_games", ["category_id"], name: "index_categories_games_on_category_id"
  add_index "categories_games", ["game_id"], name: "index_categories_games_on_game_id"

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "games", force: :cascade do |t|
    t.integer  "bgg_account_id"
    t.string   "bggid"
    t.string   "bgname"
    t.integer  "yearpublished"
    t.integer  "minplayers"
    t.integer  "maxplayers"
    t.integer  "playingtime"
    t.integer  "minplayingtime"
    t.integer  "maxplayingtime"
    t.integer  "minage"
    t.text     "boardgamedesigner"
    t.text     "boardgamepublisher"
    t.text     "boardgameexpansion"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "thumbnail"
  end

  add_index "games", ["bgg_account_id"], name: "index_games_on_bgg_account_id"

  create_table "games_mechanics", id: false, force: :cascade do |t|
    t.integer "mechanic_id"
    t.integer "game_id"
  end

  add_index "games_mechanics", ["game_id"], name: "index_games_mechanics_on_game_id"
  add_index "games_mechanics", ["mechanic_id"], name: "index_games_mechanics_on_mechanic_id"

  create_table "mechanics", force: :cascade do |t|
    t.string   "boardgamemechanic"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.text     "accounts"
    t.datetime "last_login"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
