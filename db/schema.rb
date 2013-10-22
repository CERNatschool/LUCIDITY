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

ActiveRecord::Schema.define(:version => 20131014092919) do

  create_table "flux_spectras", :force => true do |t|
    t.string   "name"
    t.text     "filetext"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "projectname"
    t.integer  "source_cards_count",           :default => 0,     :null => false
    t.text     "notes"
    t.integer  "n_events",                     :default => 10000, :null => false
    t.string   "sourcecardsfile_file_name"
    t.string   "sourcecardsfile_content_type"
    t.integer  "sourcecardsfile_file_size"
    t.datetime "sourcecardsfile_updated_at"
  end

  add_index "flux_spectras", ["name"], :name => "index_flux_spectras_on_name", :unique => true

  create_table "source_cards", :force => true do |t|
    t.integer  "n_events"
    t.string   "particle_type"
    t.decimal  "e_min",                 :precision => 30, :scale => 15
    t.decimal  "e_max",                 :precision => 30, :scale => 15
    t.decimal  "flux_integral",         :precision => 30, :scale => 15
    t.decimal  "flux_differential",     :precision => 30, :scale => 15
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flux_spectra_id"
    t.string   "cardid"
    t.string   "cardfile_file_name"
    t.string   "cardfile_content_type"
    t.integer  "cardfile_file_size"
    t.datetime "cardfile_updated_at"
  end

  add_index "source_cards", ["cardid"], :name => "index_source_cards_on_cardid", :unique => true
  add_index "source_cards", ["flux_spectra_id"], :name => "index_source_cards_on_flux_spectra_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "invited"
    t.datetime "key_timestamp"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
