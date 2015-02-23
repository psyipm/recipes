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

ActiveRecord::Schema.define(version: 20150223201425) do

  create_table "components", force: :cascade do |t|
    t.string  "title",     limit: 255
    t.integer "recipe_id", limit: 4
  end

  add_index "components", ["recipe_id"], name: "index_components_on_recipe_id", using: :btree

  create_table "fingerprints", force: :cascade do |t|
    t.string  "text",      limit: 256
    t.integer "recipe_id", limit: 4
  end

  add_index "fingerprints", ["recipe_id"], name: "index_fingerprints_on_recipe_id", using: :btree
  add_index "fingerprints", ["text"], name: "index_fingerprints_on_text", length: {"text"=>255}, using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "original",           limit: 255
    t.string   "medium",             limit: 255
    t.string   "thumb",              limit: 255
    t.integer  "recipe_id",          limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  add_index "photos", ["recipe_id"], name: "index_photos_on_recipe_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "title",      limit: 512
    t.text     "text",       limit: 65535
    t.integer  "serving",    limit: 4
    t.integer  "cook_time",  limit: 4
    t.integer  "rating",     limit: 4,     default: 0
    t.boolean  "published",  limit: 1,     default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string  "title",     limit: 255
    t.integer "recipe_id", limit: 4
  end

  add_index "tags", ["recipe_id"], name: "index_tags_on_recipe_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               limit: 255,                   null: false
    t.string   "uid",                    limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.string   "image",                  limit: 255
    t.string   "email",                  limit: 255
    t.boolean  "admin",                  limit: 1,     default: false
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "components", "recipes"
  add_foreign_key "fingerprints", "recipes"
  add_foreign_key "photos", "recipes"
  add_foreign_key "tags", "recipes"
end
