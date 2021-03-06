# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_15_033136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "pg_trgm"
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
    t.float "land_only_price"
    t.float "apartment_price"
    t.float "house_price"
    t.float "farm_price"
    t.integer "lands_count"
    t.index ["alias_name"], name: "index_addresses_on_alias_name", using: :gin
    t.index ["name"], name: "index_addresses_on_name", using: :gin
    t.index ["parent_id"], name: "index_addresses_on_parent_id"
    t.index ["slug"], name: "index_addresses_on_slug", unique: true
    t.index ["type"], name: "addresses_partial_type_address", where: "((type)::text = 'Address'::text)"
    t.index ["type"], name: "addresses_partial_type_district", where: "((type)::text = 'District'::text)"
    t.index ["type"], name: "addresses_partial_type_province", where: "((type)::text = 'Province'::text)"
    t.index ["type"], name: "addresses_partial_type_street", where: "((type)::text = 'Street'::text)"
    t.index ["type"], name: "addresses_partial_type_ward", where: "((type)::text = 'Ward'::text)"
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
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_history_prices_on_deleted_at"
    t.index ["land_id"], name: "index_history_prices_on_land_id"
    t.index ["total_price", "acreage", "land_id", "posted_date", "deleted_at"], name: "history_price_unique_index", unique: true
  end

  create_table "lands", force: :cascade do |t|
    t.float "acreage"
    t.float "total_price"
    t.float "square_meter_price"
    t.text "address_detail"
    t.bigint "street_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "source_url"
    t.text "description"
    t.date "post_date"
    t.string "slug"
    t.string "alias_title"
    t.date "expired_date"
    t.datetime "deleted_at"
    t.bigint "ward_id"
    t.bigint "district_id"
    t.bigint "province_id"
    t.integer "classification", default: 8
    t.float "front_length"
    t.bigint "user_id"
    t.jsonb "images", default: [], array: true
    t.index ["address_detail"], name: "index_lands_on_address_detail", using: :gin
    t.index ["alias_title"], name: "index_lands_on_alias_title", using: :gin
    t.index ["created_at"], name: "index_lands_on_created_at_with_calculable_columns", where: "((deleted_at IS NULL) AND ((total_price > (0)::double precision) AND (acreage > (0)::double precision)))"
    t.index ["deleted_at"], name: "index_lands_on_deleted_at"
    t.index ["district_id"], name: "index_lands_on_district_id"
    t.index ["district_id"], name: "index_lands_on_district_id_with_deleted_at", where: "((deleted_at IS NULL) AND ((total_price > (0)::double precision) AND (acreage > (0)::double precision)))"
    t.index ["post_date"], name: "index_lands_on_post_date", where: "(deleted_at IS NULL)"
    t.index ["province_id"], name: "index_lands_on_province_id"
    t.index ["province_id"], name: "index_lands_on_province_id_with_deleted_at", where: "((deleted_at IS NULL) AND ((total_price > (0)::double precision) AND (acreage > (0)::double precision)))"
    t.index ["slug"], name: "index_lands_on_slug", unique: true
    t.index ["street_id"], name: "index_lands_on_deleted_at_address_id", where: "(deleted_at IS NULL)"
    t.index ["street_id"], name: "index_lands_on_street_id"
    t.index ["street_id"], name: "index_lands_on_street_id_with_deleted_at", where: "((deleted_at IS NULL) AND ((total_price > (0)::double precision) AND (acreage > (0)::double precision)))"
    t.index ["title"], name: "index_lands_on_title", using: :gin
    t.index ["user_id"], name: "index_lands_on_user_id"
    t.index ["ward_id"], name: "index_lands_on_ward_id"
    t.index ["ward_id"], name: "index_lands_on_ward_id_with_deleted_at", where: "((deleted_at IS NULL) AND ((total_price > (0)::double precision) AND (acreage > (0)::double precision)))"
  end

  create_table "price_loggers", force: :cascade do |t|
    t.float "price"
    t.integer "loggable_id"
    t.string "loggable_type"
    t.date "logged_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lands_count", default: 0
    t.integer "lands_count_ratio"
    t.integer "price_ratio"
    t.index ["loggable_id", "loggable_type", "logged_date"], name: "logged_date_unique_index", unique: true
    t.index ["loggable_id", "loggable_type"], name: "index_price_loggers_on_loggable_id_and_loggable_type"
  end

  create_table "proxies", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "name"
    t.integer "selling_times", default: 0
    t.boolean "agency", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "lands", "addresses", column: "district_id"
  add_foreign_key "lands", "addresses", column: "province_id"
  add_foreign_key "lands", "addresses", column: "street_id"
  add_foreign_key "lands", "addresses", column: "ward_id"
  add_foreign_key "lands", "users"
end
