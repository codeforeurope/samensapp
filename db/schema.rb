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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130825180704) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "link"
    t.integer  "expires_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authorizations", ["provider", "uid"], :name => "index_authorizations_on_provider_and_uid"
  add_index "authorizations", ["provider"], :name => "index_authorizations_on_provider"
  add_index "authorizations", ["token", "uid"], :name => "index_authorizations_on_token_and_uid"
  add_index "authorizations", ["token"], :name => "index_authorizations_on_token"
  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "booking_requests", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "people"
    t.text     "description"
    t.text     "catering_needs"
    t.text     "equipment_needs"
    t.text     "notes"
    t.string   "status"
    t.integer  "submitter_id"
    t.integer  "assignee_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "code"
    t.string   "company_name"
    t.string   "contact_person"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.text     "company_address"
    t.string   "website"
    t.integer  "building_id"
  end

  add_index "booking_requests", ["code"], :name => "index_booking_requests_on_code"

  create_table "booking_statuses", :force => true do |t|
    t.string   "description"
    t.integer  "booking_request_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.float    "latitude"
    t.float    "longitude"
    t.time     "open_from"
    t.time     "open_to"
    t.text     "description"
  end

  create_table "event_charges", :force => true do |t|
    t.string   "name"
    t.decimal  "price",      :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "decimal",    :precision => 6, :scale => 2, :default => 0.0
    t.integer  "units",                                    :default => 1
    t.integer  "event_id"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  add_index "event_charges", ["event_id"], :name => "index_event_charges_on_event_id"

  create_table "event_rooms", :force => true do |t|
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "tariff"
    t.decimal  "price",             :default => 0.0
    t.integer  "units",             :default => 1
    t.string   "calendar_event_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "booking_request_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "status"
    t.string   "code"
  end

  add_index "events", ["booking_request_id"], :name => "index_events_on_booking_request_id"
  add_index "events", ["code"], :name => "index_events_on_code"
  add_index "events", ["status"], :name => "index_events_on_status"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "icon"
    t.string   "image"
    t.string   "status"
    t.text     "description"
    t.string   "email"
    t.string   "google_token"
    t.string   "google_refresh_token"
    t.integer  "google_token_expires_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "description"
    t.string   "image"
    t.integer  "attachable_picture_id"
    t.string   "attachable_picture_type"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "authorizable_type"
    t.integer  "authorizable_id"
  end

  create_table "room_configurations", :force => true do |t|
    t.integer  "room_id"
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "floor"
    t.decimal  "base_price"
    t.decimal  "blind_price"
    t.integer  "capacity"
    t.text     "description"
    t.text     "notes"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.decimal  "cleaning_fee"
    t.integer  "building_id"
    t.boolean  "rentable"
    t.integer  "minimum_block",   :default => 1
    t.string   "google_calendar"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "phone"
    t.string   "mobile_phone"
    t.text     "address"
    t.integer  "organization_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
