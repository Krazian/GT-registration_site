class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
        t.string "registration_code", unique: true
        t.integer "paperless_attendee_id", unique: true
        t.string "first_name"
        t.string "last_name"
        t.string "preferred_first_name"
        t.string "preferred_last_name"
        t.string "gender"
        t.string "email", unique: true
        t.string "mobile_number"
        t.string "mobile_device"
        t.boolean "iphone"
        t.boolean "android"
        t.boolean "blackberry"
        t.boolean "ipad"
        t.boolean "tablet"
        t.boolean "other"
        t.string "job_title"
        t.string "assistant_first_name"
        t.string "assistant_last_name"
        t.string "assistant_email"
        t.string "arrival_date_and_time"
        t.string "inbound_destination"
        t.string "departure_date_and_time"
        t.string "outbound_destination"
        t.string "require_hotel"
        t.string "emergency_first_name"
        t.string "emergency_last_name"
        t.string "emergency_mobile_number"
        t.string "emergency_relationship"
        t.string "allergies"
        t.string "professional"
        t.string "personal"
        t.string "month_of_birth"
        t.string "day_of_birth"
        t.string "hometown"
        t.string "fav_sports_team_or_player"
        t.string "fav_song"
        t.string "first_position_at_exxonmobil"
        t.string "year_started_at_exxonmobil"
        t.boolean  "submitted", default: false, null: false
        t.timestamps
    end

    create_table :api_settings do |t|
      t.string "url"
      t.integer "event_id"
      t.integer "client_id"
      t.string "api_auth_token"
      t.boolean "active"
      t.timestamps null: false
    end

    create_table :attendee_reports do |t|
        t.string "csv_file_name"
        t.string "csv_link"
        t.string "zip_file_name"
        t.string "zip_link"
      t.timestamps null: false
    end

  end
end
