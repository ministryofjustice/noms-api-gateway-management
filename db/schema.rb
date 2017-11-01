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

ActiveRecord::Schema.define(version: 20171031144858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.string   "contact_email"
    t.string   "requested_by"
    t.string   "service_name"
    t.text     "reason"
    t.text     "client_pub_key"
    t.boolean  "processed",      default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "environment_id"
    t.index ["environment_id"], name: "index_access_requests_on_environment_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "environments", force: :cascade do |t|
    t.string   "name"
    t.text     "provisioning_key"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "client_pub_key"
    t.string   "client_private_key"
    t.text     "jwt"
    t.string   "base_url"
    t.string   "health"
    t.string   "deployed_version"
    t.datetime "deployed_version_timestamp"
    t.datetime "properties_last_checked"
    t.integer  "interval",                   default: 10
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "issued_at"
    t.string   "requested_by"
    t.string   "service_name"
    t.string   "fingerprint"
    t.datetime "expires"
    t.string   "contact_email"
    t.string   "state",           default: "inactive"
    t.text     "client_pub_key"
    t.text     "trackback_token"
    t.text     "permissions"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "created_from",    default: "web"
    t.integer  "environment_id"
    t.index ["environment_id"], name: "index_tokens_on_environment_id", using: :btree
    t.index ["trackback_token"], name: "index_tokens_on_trackback_token", using: :btree
  end

end
