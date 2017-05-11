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

ActiveRecord::Schema.define(version: 20170511093928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string   "natural_key",     null: false
    t.string   "name",            null: false
    t.string   "hostname",        null: false
    t.string   "department_code", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["natural_key"], name: "index_agencies_on_natural_key", unique: true, using: :btree
  end

  create_table "departments", force: :cascade do |t|
    t.string   "natural_key", null: false
    t.string   "name",        null: false
    t.string   "hostname",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["natural_key"], name: "index_departments_on_natural_key", unique: true, using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "natural_key",     null: false
    t.string   "name",            null: false
    t.string   "hostname",        null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "department_code", null: false
    t.string   "agency_code"
    t.index ["natural_key"], name: "index_services_on_natural_key", unique: true, using: :btree
  end

  create_table "transactions_received_metrics", force: :cascade do |t|
    t.string   "department_code", null: false
    t.string   "agency_code"
    t.string   "service_code",    null: false
    t.date     "starts_on",       null: false
    t.date     "ends_on",         null: false
    t.string   "channel",         null: false
    t.bigint   "quantity",        null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "transactions_with_outcome_metrics", force: :cascade do |t|
    t.string   "department_code",                null: false
    t.string   "agency_code"
    t.string   "service_code",                   null: false
    t.date     "starts_on",                      null: false
    t.date     "ends_on",                        null: false
    t.bigint   "quantity_with_any_outcome",      null: false
    t.bigint   "quantity_with_intended_outcome", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_foreign_key "agencies", "departments", column: "department_code", primary_key: "natural_key"
  add_foreign_key "services", "agencies", column: "agency_code", primary_key: "natural_key"
  add_foreign_key "services", "departments", column: "department_code", primary_key: "natural_key"
  add_foreign_key "transactions_received_metrics", "agencies", column: "agency_code", primary_key: "natural_key"
  add_foreign_key "transactions_received_metrics", "departments", column: "department_code", primary_key: "natural_key"
  add_foreign_key "transactions_received_metrics", "services", column: "service_code", primary_key: "natural_key"
  add_foreign_key "transactions_with_outcome_metrics", "agencies", column: "agency_code", primary_key: "natural_key"
  add_foreign_key "transactions_with_outcome_metrics", "departments", column: "department_code", primary_key: "natural_key"
  add_foreign_key "transactions_with_outcome_metrics", "services", column: "service_code", primary_key: "natural_key"
end
