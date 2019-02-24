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

ActiveRecord::Schema.define(version: 2019_02_24_205423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inspirations", force: :cascade do |t|
    t.string "inspiration_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.integer "duration"
    t.string "url"
    t.string "name"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "start_point"
    t.string "end_point"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "status"
    t.bigint "itinerary_id"
    t.bigint "inspiration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspiration_id"], name: "index_suggestions_on_inspiration_id"
    t.index ["itinerary_id"], name: "index_suggestions_on_itinerary_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "itineraries", "users"
  add_foreign_key "suggestions", "inspirations"
  add_foreign_key "suggestions", "itineraries"
end
