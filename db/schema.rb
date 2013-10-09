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

ActiveRecord::Schema.define(version: 20131009134736) do

  create_table "questions", force: true do |t|
    t.string   "original_text", limit: 140,                null: false
    t.string   "display_text",  limit: 140,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                    default: true, null: false
    t.string   "neighbourhood"
    t.string   "name"
    t.string   "email"
    t.boolean  "anonymous"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "password_digest"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "voting_round_questions", force: true do |t|
    t.integer  "voting_round_id"
    t.integer  "question_id"
    t.integer  "vote_number",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voting_rounds", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
