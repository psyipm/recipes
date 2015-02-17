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

ActiveRecord::Schema.define(version: 20150128113036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "components", force: :cascade do |t|
    t.string  "title"
    t.integer "recipe_id"
  end

  add_index "components", ["recipe_id"], name: "index_components_on_recipe_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "recipe_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "original"
    t.string   "medium"
    t.string   "thumb"
  end

  add_index "photos", ["recipe_id"], name: "index_photos_on_recipe_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "title",      limit: 512
    t.text     "text"
    t.integer  "serving"
    t.integer  "cook_time"
    t.integer  "rating",                 default: 0
    t.boolean  "published",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string  "title"
    t.integer "recipe_id"
  end

  add_index "tags", ["recipe_id"], name: "index_tags_on_recipe_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",                               null: false
    t.string   "uid",                    default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.boolean  "admin",                  default: false
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "components", "recipes"
  add_foreign_key "photos", "recipes"
  add_foreign_key "tags", "recipes"
end
