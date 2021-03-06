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

ActiveRecord::Schema.define(version: 20171231134636) do

  create_table "accounts", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.decimal "balance", precision: 10, scale: 2
    t.string "currency"
    t.string "nature"
    t.integer "login_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_accounts_on_login_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "customer_id"
    t.string "identifier"
    t.string "secret"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "logins", force: :cascade do |t|
    t.integer "login_id"
    t.string "hashid"
    t.string "status"
    t.string "provider"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_refresh_possible_at"
    t.index ["customer_id"], name: "index_logins_on_customer_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_id"
    t.string "category"
    t.string "currency"
    t.decimal "amount", precision: 10, scale: 2
    t.string "description"
    t.string "made_on"
    t.string "mode"
    t.string "status"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
