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

ActiveRecord::Schema.define(version: 20150117160702) do

  create_table "components", force: :cascade do |t|
    t.string  "title",     limit: 255
    t.integer "recipe_id", limit: 4
  end

  add_index "components", ["recipe_id"], name: "index_components_on_recipe_id", using: :btree

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
    t.integer  "rating",     limit: 4
    t.boolean  "published",  limit: 1,     default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string  "title",     limit: 255
    t.integer "recipe_id", limit: 4
  end

  add_index "tags", ["recipe_id"], name: "index_tags_on_recipe_id", using: :btree

  add_foreign_key "components", "recipes"
  add_foreign_key "photos", "recipes"
  add_foreign_key "tags", "recipes"
end
