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

ActiveRecord::Schema.define(version: 2019_10_07_064740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.text "username"
    t.text "name"
    t.text "email"
    t.text "password_digest"
    t.integer "favorite_genres", default: [], array: true
    t.date "dob"
    t.text "favorite_food", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "favorite_cinema_id"
    t.index ["favorite_cinema_id"], name: "index_accounts_on_favorite_cinema_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.text "street"
    t.text "apt_number"
    t.text "city"
    t.text "state"
    t.text "postal_code"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["account_id"], name: "index_addresses_on_account_id"
  end

  create_table "favorite_cinemas", force: :cascade do |t|
    t.integer "movie_glu_cinema_id"
    t.text "name"
    t.text "address"
    t.text "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_picks", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "restaurant_id"
    t.text "restaurant_name"
    t.text "restaurant_image_url"
    t.text "cuisines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_food_picks_on_account_id"
  end

  create_table "movie_picks", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "movie_id"
    t.text "movie_name"
    t.text "movie_poster_url"
    t.text "start_time"
    t.text "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "movie_picked_at"
    t.text "cinema_name"
    t.text "show_time_type"
    t.index ["account_id"], name: "index_movie_picks_on_account_id"
  end

  add_foreign_key "addresses", "accounts"
  add_foreign_key "food_picks", "accounts"
  add_foreign_key "movie_picks", "accounts"
end
