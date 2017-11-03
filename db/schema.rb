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

ActiveRecord::Schema.define(version: 20161012160803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree
  end

  create_table "api_settings", force: :cascade do |t|
    t.string   "url"
    t.integer  "event_id"
    t.integer  "client_id"
    t.string   "api_auth_token"
    t.boolean  "active"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "attendee_reports", force: :cascade do |t|
    t.string   "csv_file_name"
    t.string   "csv_link"
    t.string   "zip_file_name"
    t.string   "zip_link"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "registration_code"
    t.integer  "paperless_attendee_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "preferred_first_name"
    t.string   "preferred_last_name"
    t.string   "gender"
    t.string   "email"
    t.string   "mobile_number"
    t.string   "mobile_device"
    t.boolean  "iphone"
    t.boolean  "android"
    t.boolean  "blackberry"
    t.boolean  "ipad"
    t.boolean  "tablet"
    t.boolean  "other"
    t.string   "job_title"
    t.string   "assistant_first_name"
    t.string   "assistant_last_name"
    t.string   "assistant_email"
    t.string   "arrival_date_and_time"
    t.string   "inbound_destination"
    t.string   "departure_date_and_time"
    t.string   "outbound_destination"
    t.string   "require_hotel"
    t.string   "emergency_first_name"
    t.string   "emergency_last_name"
    t.string   "emergency_mobile_number"
    t.string   "emergency_relationship"
    t.string   "allergies"
    t.string   "professional"
    t.string   "personal"
    t.string   "month_of_birth"
    t.string   "day_of_birth"
    t.string   "hometown"
    t.string   "fav_sports_team_or_player"
    t.string   "fav_song"
    t.string   "first_position_at_exxonmobil"
    t.string   "year_started_at_exxonmobil"
    t.boolean  "submitted",                    default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end
