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

ActiveRecord::Schema.define(version: 20141011081955) do

  create_table "books", force: true do |t|
    t.string   "douban_book_id",                 null: false
    t.string   "name",           default: ""
    t.string   "authors",        default: ""
    t.string   "image_href",     default: ""
    t.string   "price",          default: ""
    t.string   "publisher",      default: ""
    t.string   "publish_date",   default: ""
    t.text     "description",    default: ""
    t.text     "author_info",    default: ""
    t.boolean  "available",      default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "borrows", force: true do |t|
    t.string   "douban_book_id"
    t.string   "borrower_id"
    t.string   "lender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "douban_book_id"
    t.text     "content"
    t.string   "user_name",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "access_token"
    t.string   "name",         default: ""
    t.string   "phone_number", default: ""
    t.string   "location",     default: ""
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.string   "avatar_url",   default: ""
  end

end
