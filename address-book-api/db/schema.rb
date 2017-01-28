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

ActiveRecord::Schema.define(version: 20170128161737) do

  create_table "contact_details", force: :cascade do |t|
    t.string   "email"
    t.string   "phone_number"
    t.string   "street_address"
    t.string   "additional_street_address"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",               null: false
    t.integer  "contact_details_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["contact_details_id"], name: "index_people_on_contact_details_id", unique: true
    t.index ["name"], name: "index_people_on_name"
  end

end
