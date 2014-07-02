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

ActiveRecord::Schema.define(version: 20140702125007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "name"
    t.string   "document_type"
    t.string   "upload_url"
    t.integer  "project_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["project_id"], name: "index_documents_on_project_id", using: :btree
  add_index "documents", ["task_id"], name: "index_documents_on_task_id", using: :btree

  create_table "invitations", force: true do |t|
    t.text     "notes"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "inviting_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "labels", ["project_id"], name: "index_labels_on_project_id", using: :btree

  create_table "labels_tasks", id: false, force: true do |t|
    t.integer "label_id"
    t.integer "task_id"
  end

  create_table "notes", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "project_id"
    t.integer  "task_id"
    t.integer  "meeting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["meeting_id"], name: "index_notes_on_meeting_id", using: :btree
  add_index "notes", ["project_id"], name: "index_notes_on_project_id", using: :btree
  add_index "notes", ["task_id"], name: "index_notes_on_task_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "deadline"
    t.integer  "percent_done"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "projects_users", id: false, force: true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "deadline"
    t.string   "task_type"
    t.string   "priority"
    t.string   "state"
    t.integer  "time_spent"
    t.integer  "time_estimated"
    t.integer  "depends_on_task_id"
    t.integer  "label_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "tasks", ["label_id"], name: "index_tasks_on_label_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "user_name"
    t.string   "authentication_token"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",   default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
