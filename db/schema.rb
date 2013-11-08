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

ActiveRecord::Schema.define(version: 20131108211535) do

  create_table "answers", force: true do |t|
    t.text     "label",       null: false
    t.text     "url",         null: false
    t.integer  "question_id", null: false
    t.string   "type",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text     "original_text",                                               null: false
    t.text     "display_text",                                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "neighbourhood"
    t.string   "name"
    t.string   "email"
    t.boolean  "anonymous"
    t.string   "picture_url"
    t.string   "picture_owner",                      default: "Curious City"
    t.string   "picture_attribution_url"
    t.string   "reporter"
    t.string   "status",                  limit: 50, default: "New",          null: false
    t.boolean  "featured",                           default: false
  end

  add_index "questions", ["status"], name: "index_questions_on_status", using: :btree

  create_table "questions_categories", id: false, force: true do |t|
    t.integer "question_id"
    t.integer "category_id"
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
    t.string   "label",      limit: 50
    t.string   "status",     limit: 20, default: "New", null: false
  end

  add_index "voting_rounds", ["label"], name: "index_voting_rounds_on_label", using: :btree
  add_index "voting_rounds", ["status"], name: "index_voting_rounds_on_status", using: :btree

end
