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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170815023204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "async_request_jobs", force: :cascade do |t|
    t.string   "worker"
    t.integer  "status"
    t.integer  "status_code"
    t.text     "response"
    t.string   "uid"
    t.text     "params"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "async_request_jobs", ["status"], name: "index_async_request_jobs_on_status", using: :btree
  add_index "async_request_jobs", ["uid"], name: "index_async_request_jobs_on_uid", unique: true, using: :btree

end
