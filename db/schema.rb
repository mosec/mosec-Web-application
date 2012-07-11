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

ActiveRecord::Schema.define(:version => 20120711033757) do

  create_table "contacts", :force => true do |t|
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "uid",              :null => false
    t.string   "full_name",        :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "contacts", ["contactable_id", "contactable_type"], :name => "index_contacts_on_contactable_id_and_contactable_type"
  add_index "contacts", ["uid"], :name => "index_contacts_on_uid"

  create_table "email_addresses", :force => true do |t|
    t.integer  "contact_id",    :null => false
    t.string   "email_address", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "email_addresses", ["contact_id"], :name => "index_email_addresses_on_contact_id"
  add_index "email_addresses", ["email_address"], :name => "index_email_addresses_on_email_address"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "contact_id",         :null => false
    t.string   "phone_number",       :null => false
    t.string   "clean_phone_number", :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "phone_numbers", ["clean_phone_number"], :name => "index_phone_numbers_on_clean_phone_number"
  add_index "phone_numbers", ["contact_id"], :name => "index_phone_numbers_on_contact_id"

  create_table "sources", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "type",       :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sources", ["type"], :name => "index_sources_on_type"
  add_index "sources", ["uid", "provider"], :name => "index_sources_on_uid_and_provider"

  create_table "users", :force => true do |t|
    t.string   "full_name",                                                 :null => false
    t.string   "email_address",                                             :null => false
    t.string   "password_digest",                                           :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "time_zone",       :default => "Eastern Time (US & Canada)", :null => false
  end

  add_index "users", ["email_address"], :name => "index_users_on_email_address"

end
