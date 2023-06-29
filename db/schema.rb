# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_29_020600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collected_plants", force: :cascade do |t|
    t.integer "user_id"
    t.string "plant_id"
    t.string "nickname"
    t.text "notes"
    t.string "custom_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "common_name"
    t.string "latin_name"
    t.string "img"
    t.string "watering"
    t.string "light_ideal"
    t.string "light_tolerated"
    t.string "climate"
    t.string "category"
    t.string "url"
  end

  create_table "plants", id: :serial, force: :cascade do |t|
    t.string "common_name"
    t.string "latin_name"
    t.string "img"
    t.string "watering"
    t.string "light_ideal"
    t.string "light_tolerated"
    t.string "climate"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "user_id"
    t.integer "collected_plant_id"
    t.integer "days_to_water"
    t.datetime "watering_start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "profile_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
