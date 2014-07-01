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

ActiveRecord::Schema.define(version: 20140701103346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: true do |t|
    t.string  "name",                           null: false
    t.text    "description"
    t.integer "strength",       default: 0
    t.integer "room_id"
    t.integer "quest_id"
    t.string  "classification",                 null: false
    t.boolean "dead",           default: false
  end

  add_index "characters", ["quest_id"], name: "index_characters_on_quest_id", using: :btree
  add_index "characters", ["room_id"], name: "index_characters_on_room_id", using: :btree

  create_table "inventory", force: true do |t|
    t.integer "player_id", null: false
    t.integer "item_id",   null: false
    t.integer "quest_id",  null: false
  end

  add_index "inventory", ["player_id", "item_id"], name: "index_inventory_on_player_id_and_item_id", using: :btree
  add_index "inventory", ["player_id", "quest_id"], name: "index_inventory_on_player_id_and_quest_id", using: :btree

  create_table "items", force: true do |t|
    t.string  "name",                       null: false
    t.text    "description",                null: false
    t.string  "classification"
    t.string  "actions"
    t.integer "parent_item",    default: 0
    t.integer "room_id"
  end

  create_table "players", force: true do |t|
    t.string  "username",                    null: false
    t.string  "password",                    null: false
    t.text    "description"
    t.integer "strength",    default: 100
    t.boolean "dead",        default: false
    t.integer "room_id"
  end

  add_index "players", ["username"], name: "index_players_on_username", using: :btree

  create_table "quest_characters", force: true do |t|
    t.integer "quest_id",     null: false
    t.integer "room_id",      null: false
    t.integer "character_id", null: false
    t.integer "player_id",    null: false
  end

  add_index "quest_characters", ["player_id", "character_id"], name: "index_quest_characters_on_player_id_and_character_id", using: :btree
  add_index "quest_characters", ["player_id", "quest_id", "room_id"], name: "index_quest_characters_on_player_id_and_quest_id_and_room_id", using: :btree

  create_table "quest_items", force: true do |t|
    t.integer "item_id",  null: false
    t.integer "quest_id", null: false
    t.integer "room_id",  null: false
  end

  add_index "quest_items", ["item_id"], name: "index_quest_items_on_item_id", using: :btree
  add_index "quest_items", ["quest_id", "room_id", "item_id"], name: "index_quest_items_on_quest_id_and_room_id_and_item_id", using: :btree

  create_table "quest_progress", force: true do |t|
    t.integer "quest_id",                  null: false
    t.integer "player_id",                 null: false
    t.boolean "complete",  default: false
    t.text    "data"
    t.integer "room_id"
  end

  add_index "quest_progress", ["player_id", "quest_id"], name: "index_quest_progress_on_player_id_and_quest_id", using: :btree

  create_table "quests", force: true do |t|
    t.string "name", null: false
  end

  create_table "room_items", force: true do |t|
    t.integer "quest_id",       null: false
    t.integer "room_id",        null: false
    t.integer "player_id",      null: false
    t.integer "item_id",        null: false
    t.integer "parent_item_id"
  end

  add_index "room_items", ["player_id", "quest_id"], name: "index_room_items_on_player_id_and_quest_id", using: :btree
  add_index "room_items", ["player_id", "room_id", "item_id"], name: "index_room_items_on_player_id_and_room_id_and_item_id", using: :btree

  create_table "rooms", force: true do |t|
    t.string  "name",                            null: false
    t.text    "description",                     null: false
    t.integer "north"
    t.integer "east"
    t.integer "south"
    t.integer "west"
    t.boolean "canN",            default: true
    t.boolean "canE",            default: true
    t.boolean "canS",            default: true
    t.boolean "canW",            default: true
    t.integer "quest_id"
    t.boolean "start_new_quest", default: false
  end

end
