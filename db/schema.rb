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

ActiveRecord::Schema.define(version: 20170428092008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "app_name"
    t.string   "api_env"
    t.text     "reason"
    t.text     "client_pub_key"
    t.text     "pgp_key"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "issued_at"
    t.string   "requested_by"
    t.string   "client_name"
    t.string   "fingerprint"
    t.string   "api_env"
    t.datetime "expires"
    t.string   "contact_email"
    t.boolean  "revoked",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

end
