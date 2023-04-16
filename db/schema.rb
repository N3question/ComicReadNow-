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

ActiveRecord::Schema.define(version: 2023_04_10_221105) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comic_id"], name: "index_bookmarks_on_comic_id"
    t.index ["user_id", "comic_id"], name: "index_bookmarks_on_user_id_and_comic_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "can_read_judgements", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "readable_info_id", null: false
    t.boolean "can_read", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["readable_info_id"], name: "index_can_read_judgements_on_readable_info_id"
    t.index ["user_id"], name: "index_can_read_judgements_on_user_id"
  end

  create_table "comic_comic_sites", force: :cascade do |t|
    t.integer "comic_id", null: false
    t.integer "comic_site_id", null: false
    t.integer "readable_info_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comic_id"], name: "index_comic_comic_sites_on_comic_id"
    t.index ["comic_site_id"], name: "index_comic_comic_sites_on_comic_site_id"
    t.index ["readable_info_id"], name: "index_comic_comic_sites_on_readable_info_id"
  end

  create_table "comic_sites", force: :cascade do |t|
    t.string "site_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comics", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rakuten_books", primary_key: "isbn", id: :bigint, default: nil, force: :cascade do |t|
    t.string "title", null: false
    t.string "author", null: false
    t.string "image_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "readable_infos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comic_id"], name: "index_readable_infos_on_comic_id"
    t.index ["user_id"], name: "index_readable_infos_on_user_id"
  end

  create_table "user_rankings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nick_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "users"
  add_foreign_key "bookmarks", "users", column: "comic_id"
  add_foreign_key "can_read_judgements", "readable_infos"
  add_foreign_key "can_read_judgements", "users"
  add_foreign_key "comic_comic_sites", "comic_sites"
  add_foreign_key "comic_comic_sites", "comics"
  add_foreign_key "comic_comic_sites", "readable_infos"
  add_foreign_key "readable_infos", "comics"
  add_foreign_key "readable_infos", "users"
end
