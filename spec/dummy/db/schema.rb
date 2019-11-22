# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_08_15_023204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "async_request_jobs", id: :serial, force: :cascade do |t|
    t.string "worker"
    t.integer "status"
    t.integer "status_code"
    t.text "response"
    t.string "uid"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_async_request_jobs_on_status"
    t.index ["uid"], name: "index_async_request_jobs_on_uid", unique: true
  end

end
