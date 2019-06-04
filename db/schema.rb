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

ActiveRecord::Schema.define(version: 2019_05_19_092047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "ward"
    t.string "district"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_page"
    t.string "province"
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
