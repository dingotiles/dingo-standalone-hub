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

ActiveRecord::Schema.define(version: 20170228092440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "guid"
    t.index ["email"], name: "index_accounts_on_email", using: :btree
  end

  create_table "archives", force: :cascade do |t|
    t.string   "method"
    t.json     "credentials"
    t.integer  "account_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["account_id"], name: "index_archives_on_account_id", using: :btree
  end

  create_table "cluster_etcds", force: :cascade do |t|
    t.json     "credentials"
    t.integer  "cluster_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["cluster_id"], name: "index_cluster_etcds_on_cluster_id", using: :btree
  end

  create_table "cluster_nodes", force: :cascade do |t|
    t.integer  "cluster_id"
    t.string   "name"
    t.string   "image_version"
    t.string   "state",         default: "starting"
    t.string   "role"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["cluster_id"], name: "index_cluster_nodes_on_cluster_id", using: :btree
  end

  create_table "clusters", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "archive_method"
    t.string   "state",          default: "starting"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "guid"
    t.index ["account_id"], name: "index_clusters_on_account_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

  add_foreign_key "archives", "accounts"
  add_foreign_key "cluster_etcds", "clusters"
  add_foreign_key "cluster_nodes", "clusters"
  add_foreign_key "clusters", "accounts"
  add_foreign_key "users", "accounts"
end
