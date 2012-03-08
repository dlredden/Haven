# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101028213641) do

  create_table "account_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "role",       :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_id"
    t.date     "next_bill_date"
    t.decimal  "bill_amount",    :precision => 6, :scale => 2
  end

  create_table "active_files", :force => true do |t|
    t.string   "name",            :limit => 50
    t.string   "path",                                           :null => false
    t.integer  "project_id",                                     :null => false
    t.integer  "account_user_id",                                :null => false
    t.datetime "touched_at"
    t.string   "is_saved",        :limit => 1,  :default => "t"
    t.string   "is_committed",    :limit => 1,  :default => "t"
    t.string   "is_published",    :limit => 1,  :default => "t"
    t.integer  "file_type_id"
  end

  add_index "active_files", ["account_user_id", "project_id", "path"], :name => "fileactivity_idx1"

  create_table "file_types", :force => true do |t|
    t.string   "extention"
    t.string   "type"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price",            :limit => 10, :precision => 10, :scale => 0
    t.boolean  "is_active",                                                     :default => true
    t.integer  "users_allowed"
    t.integer  "projects_allowed"
  end

  create_table "projects", :force => true do |t|
    t.string  "name",          :null => false
    t.string  "root_path"
    t.integer "account_id"
    t.integer "repository_id"
  end

  create_table "repositories", :force => true do |t|
    t.string  "address",            :null => false
    t.integer "repository_type_id"
    t.binary  "username"
    t.binary  "username_key"
    t.binary  "username_iv"
    t.binary  "password"
    t.binary  "password_key"
    t.binary  "password_iv"
  end

  create_table "repository_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "select_values", :force => true do |t|
    t.string "value",  :default => "\"\""
    t.string "value2"
    t.string "key",    :default => "\"\""
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "hashed_password", :limit => 40, :default => "", :null => false
    t.string   "first_name",      :limit => 25, :default => "", :null => false
    t.string   "last_name",       :limit => 40, :default => "", :null => false
    t.string   "email",           :limit => 50, :default => "", :null => false
    t.string   "salt",            :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone"
  end

end
