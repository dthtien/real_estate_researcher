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

ActiveRecord::Schema.define(version: 2019_07_30_162649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_page"
    t.string "name"
    t.string "alias_name"
    t.string "type"
    t.integer "parent_id"
    t.boolean "finish", default: false
    t.string "scrapping_link", default: "{}"
    t.integer "scrapping_page", default: 0
    t.string "slug"
    t.index ["parent_id"], name: "index_addresses_on_parent_id"
    t.index ["slug"], name: "index_addresses_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "history_prices", force: :cascade do |t|
    t.float "total_price"
    t.float "acreage"
    t.bigint "land_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "square_meter_price"
    t.date "posted_date"
    t.index ["land_id"], name: "index_history_prices_on_land_id"
  end

  create_table "lands", force: :cascade do |t|
    t.float "acreage"
    t.float "total_price"
    t.float "square_meter_price"
    t.text "address_detail"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "source_url"
    t.text "description"
    t.date "post_date"
    t.index ["address_id"], name: "index_lands_on_address_id"
  end

  add_foreign_key "lands", "addresses"
end
