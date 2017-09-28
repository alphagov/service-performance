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

ActiveRecord::Schema.define(version: 20170928100829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "monthly_service_metrics", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.date "month", null: false
    t.integer "online_transactions"
    t.integer "phone_transactions"
    t.integer "paper_transactions"
    t.integer "face_to_face_transactions"
    t.integer "other_transactions"
    t.integer "transactions_with_outcome"
    t.integer "transactions_with_intended_outcome"
    t.integer "calls_received"
    t.integer "calls_received_get_information"
    t.integer "calls_received_chase_progress"
    t.integer "calls_received_challenge_decision"
    t.integer "calls_received_other"
    t.integer "calls_received_perform_transaction"
    t.index "service_id, date_trunc('month'::text, (month)::timestamp without time zone)", name: "unique_monthly_service_metrics", unique: true
    t.index ["service_id"], name: "index_monthly_service_metrics_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.text "purpose"
    t.text "how_it_works"
    t.text "typical_users"
    t.text "frequency_used"
    t.text "duration_until_outcome"
    t.string "start_page_url"
    t.string "paper_form_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publish_token"
    t.index ["publish_token"], name: "index_services_on_publish_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "monthly_service_metrics", "services"
end
