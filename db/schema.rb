# frozen_string_literal: true

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

ActiveRecord::Schema[8.0].define(version: 20_250_430_180_544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'companies', force: :cascade do |t|
    t.string 'name'
    t.string 'cnpj'
    t.string 'cep'
    t.string 'street'
    t.integer 'number'
    t.string 'city'
    t.string 'state'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['cnpj'], name: 'index_companies_on_cnpj', unique: true
    t.index ['user_id'], name: 'index_companies_on_user_id'
  end

  create_table 'order_items', force: :cascade do |t|
    t.string 'code'
    t.string 'product'
    t.float 'price'
    t.integer 'quantity'
    t.string 'ean_code'
    t.bigint 'order_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_order_items_on_order_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.string 'description'
    t.string 'admin_feedback'
    t.string 'status', default: 'pending'
    t.bigint 'company_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['company_id'], name: 'index_orders_on_company_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.string 'name'
    t.string 'cpf'
    t.string 'phone'
    t.string 'role'
    t.string 'verification_token'
    t.datetime 'verification_token_sent_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['cpf'], name: 'index_users_on_cpf', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'companies', 'users'
  add_foreign_key 'order_items', 'orders'
  add_foreign_key 'orders', 'companies'
end
