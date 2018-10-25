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

ActiveRecord::Schema.define(version: 20181025080748) do

  create_table "care_homes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "address"
    t.string   "town",                          limit: 100
    t.string   "postcode",                      limit: 8
    t.float    "base_rate",                     limit: 24
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.text     "image_url",                     limit: 65535
    t.decimal  "lat",                                         precision: 18, scale: 15
    t.decimal  "lng",                                         precision: 18, scale: 15
    t.datetime "deleted_at"
    t.boolean  "verified"
    t.string   "zone",                          limit: 10
    t.string   "cqc_location",                  limit: 50
    t.integer  "total_rating"
    t.integer  "rating_count"
    t.string   "bank_account",                  limit: 8
    t.string   "sort_code",                     limit: 6
    t.boolean  "accept_bank_transactions"
    t.datetime "accept_bank_transactions_date"
    t.string   "phone",                         limit: 12
    t.boolean  "manual_assignment_flag"
    t.string   "speciality",                    limit: 100
    t.string   "care_home_broadcast_group"
    t.string   "preferred_care_giver_ids"
    t.index ["cqc_location"], name: "index_care_homes_on_cqc_location", using: :btree
    t.index ["deleted_at"], name: "index_care_homes_on_deleted_at", using: :btree
  end

  create_table "cqc_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "aka"
    t.string   "address"
    t.string   "postcode"
    t.string   "phone"
    t.string   "website"
    t.text     "service_types",   limit: 65535
    t.text     "services",        limit: 65535
    t.string   "local_authority"
    t.string   "region"
    t.string   "cqc_url"
    t.string   "cqc_location"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["cqc_location"], name: "index_cqc_records_on_cqc_location", using: :btree
    t.index ["postcode"], name: "index_cqc_records_on_postcode", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "hiring_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "start_date"
    t.string   "start_time",   limit: 20
    t.date     "end_date"
    t.integer  "num_of_hours"
    t.float    "rate",         limit: 24
    t.string   "req_type",     limit: 20
    t.integer  "user_id"
    t.integer  "hospital_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "hiring_responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "hiring_request_id"
    t.text     "notes",             limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "holidays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         limit: 100
    t.date     "date"
    t.boolean  "bank_holiday"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["date"], name: "index_holidays_on_date", using: :btree
  end

  create_table "login_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "scope"
    t.string   "strategy"
    t.string   "identity"
    t.boolean  "success"
    t.string   "failure_reason"
    t.string   "user_type"
    t.integer  "user_id"
    t.string   "context"
    t.string   "ip"
    t.text     "user_agent",     limit: 65535
    t.text     "referrer",       limit: 65535
    t.string   "city"
    t.string   "region"
    t.string   "country"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity", using: :btree
    t.index ["ip"], name: "index_login_activities_on_ip", using: :btree
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user_type_and_user_id", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "shift_id"
    t.integer  "user_id"
    t.integer  "care_home_id"
    t.integer  "paid_by_id"
    t.float    "amount",              limit: 24
    t.text     "notes",               limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "staffing_request_id"
    t.datetime "deleted_at"
    t.float    "billing",             limit: 24
    t.float    "vat",                 limit: 24
    t.float    "markup",              limit: 24
    t.float    "care_giver_amount",   limit: 24
    t.index ["care_home_id"], name: "index_payments_on_care_home_id", using: :btree
    t.index ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
    t.index ["shift_id"], name: "index_payments_on_shift_id", using: :btree
    t.index ["staffing_request_id"], name: "index_payments_on_staffing_request_id", using: :btree
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "post_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "postcode",           limit: 10
    t.decimal "latitude",                      precision: 10
    t.decimal "longitude",                     precision: 10
    t.string  "postcode_wo_spaces"
    t.index ["postcode"], name: "index_postcodelatlng_on_postcode", using: :btree
  end

  create_table "postcodelatlng", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
    t.string  "postcode",           limit: 8,                           null: false
    t.decimal "latitude",                     precision: 18, scale: 15, null: false
    t.decimal "longitude",                    precision: 18, scale: 15, null: false
    t.string  "postcode_wo_spaces"
    t.index ["postcode"], name: "index_postcodelatlng_on_postcode", using: :btree
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.date     "date_of_CRB_DBS_check"
    t.date     "dob"
    t.string   "pin",                             limit: 15
    t.boolean  "enhanced_crb"
    t.boolean  "crd_dbs_returned"
    t.boolean  "isa_returned"
    t.string   "crd_dbs_number",                  limit: 20
    t.boolean  "eligible_to_work_UK"
    t.boolean  "confirmation_of_identity"
    t.date     "references_received"
    t.boolean  "dl_passport"
    t.boolean  "all_required_paperwork_checked"
    t.boolean  "registered_under_disability_act"
    t.boolean  "connuct_policies"
    t.string   "form_completed_by",               limit: 50
    t.string   "position",                        limit: 25
    t.date     "date_sent"
    t.date     "date_received"
    t.string   "known_as",                        limit: 50
    t.string   "role",                            limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "zone"
    t.string   "role"
    t.string   "speciality"
    t.float    "amount",                  limit: 24
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.float    "carer_weekday",           limit: 24
    t.float    "care_home_weekday",       limit: 24
    t.float    "carer_weeknight",         limit: 24
    t.float    "care_home_weeknight",     limit: 24
    t.float    "carer_weekend",           limit: 24
    t.float    "care_home_weekend",       limit: 24
    t.float    "carer_weekend_night",     limit: 24
    t.float    "care_home_weekend_night", limit: 24
    t.float    "carer_bank_holiday",      limit: 24
    t.float    "care_home_bank_holiday",  limit: 24
  end

  create_table "ratings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "shift_id"
    t.integer  "stars"
    t.text     "comments",          limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "created_by_id"
    t.integer  "care_home_id"
    t.datetime "deleted_at"
    t.integer  "rated_entity_id"
    t.string   "rated_entity_type", limit: 20
    t.index ["deleted_at"], name: "index_ratings_on_deleted_at", using: :btree
    t.index ["rated_entity_id"], name: "index_ratings_on_rated_entity_id", using: :btree
    t.index ["rated_entity_type"], name: "index_ratings_on_rated_entity_type", using: :btree
    t.index ["shift_id"], name: "index_ratings_on_shift_id", using: :btree
  end

  create_table "referrals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name",      limit: 50
    t.string   "last_name",       limit: 50
    t.string   "email"
    t.string   "role",            limit: 15
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "referral_status", limit: 10
    t.string   "payment_status",  limit: 10
    t.index ["email"], name: "index_referrals_on_email", using: :btree
    t.index ["user_id"], name: "index_referrals_on_user_id", using: :btree
  end

  create_table "shifts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "staffing_request_id"
    t.integer  "user_id"
    t.string   "start_code",                    limit: 10
    t.string   "end_code",                      limit: 10
    t.string   "response_status",               limit: 20
    t.boolean  "accepted"
    t.boolean  "rated"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "care_home_id"
    t.string   "payment_status",                limit: 10
    t.datetime "deleted_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "carer_base",                    limit: 24
    t.text     "pricing_audit",                 limit: 65535
    t.integer  "confirm_sent_count"
    t.date     "confirm_sent_at"
    t.string   "confirmed_status",              limit: 20
    t.integer  "confirmed_count"
    t.date     "confirmed_at"
    t.boolean  "viewed"
    t.boolean  "care_home_rated"
    t.string   "care_home_payment_status",      limit: 10
    t.float    "markup",                        limit: 24
    t.float    "care_home_total_amount",        limit: 24
    t.float    "vat",                           limit: 24
    t.float    "care_home_base",                limit: 24
    t.integer  "day_mins_worked"
    t.integer  "night_mins_worked"
    t.integer  "total_mins_worked"
    t.boolean  "manual_close"
    t.boolean  "preferred_care_giver_selected"
    t.integer  "notification_count"
    t.index ["care_home_id"], name: "index_shifts_on_care_home_id", using: :btree
    t.index ["deleted_at"], name: "index_shifts_on_deleted_at", using: :btree
    t.index ["staffing_request_id"], name: "index_shifts_on_staffing_request_id", using: :btree
    t.index ["user_id"], name: "index_shifts_on_user_id", using: :btree
  end

  create_table "staffing_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "care_home_id"
    t.integer  "user_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "rate_per_hour",          limit: 24
    t.string   "request_status",         limit: 20
    t.float    "auto_deny_in",           limit: 24
    t.integer  "response_count"
    t.string   "payment_status",         limit: 20
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "start_code",             limit: 10
    t.string   "end_code",               limit: 10
    t.string   "broadcast_status"
    t.datetime "deleted_at"
    t.string   "role",                   limit: 20
    t.string   "speciality",             limit: 100
    t.text     "pricing_audit",          limit: 65535
    t.float    "care_home_base",         limit: 24
    t.string   "shift_status"
    t.float    "vat",                    limit: 24
    t.float    "care_home_total_amount", limit: 24
    t.boolean  "manual_assignment_flag"
    t.float    "carer_base",             limit: 24
    t.index ["care_home_id"], name: "index_staffing_requests_on_care_home_id", using: :btree
    t.index ["deleted_at"], name: "index_staffing_requests_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_staffing_requests_on_user_id", using: :btree
  end

  create_table "staffing_responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "staffing_request_id"
    t.integer  "user_id"
    t.string   "start_code",          limit: 10
    t.string   "end_code",            limit: 10
    t.string   "response_status",     limit: 20
    t.boolean  "accepted"
    t.boolean  "rated"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "care_home_id"
    t.string   "payment_status",      limit: 10
    t.datetime "deleted_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "price",               limit: 24
    t.text     "pricing_audit",       limit: 65535
    t.integer  "confirm_sent_count"
    t.date     "confirm_sent_at"
    t.string   "confirmed_status",    limit: 20
    t.integer  "confirmed_count"
    t.date     "confirmed_at"
    t.boolean  "viewed"
    t.index ["care_home_id"], name: "index_staffing_responses_on_care_home_id", using: :btree
    t.index ["deleted_at"], name: "index_staffing_responses_on_deleted_at", using: :btree
    t.index ["staffing_request_id"], name: "index_staffing_responses_on_staffing_request_id", using: :btree
    t.index ["user_id"], name: "index_staffing_responses_on_user_id", using: :btree
  end

  create_table "stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",        limit: 100
    t.string   "description"
    t.string   "value"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.date     "as_of_date"
    t.string   "date_range",  limit: 40
    t.string   "stat_type",   limit: 20
  end

  create_table "trainings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.boolean  "undertaken"
    t.date     "date_completed"
    t.integer  "profile_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["profile_id"], name: "index_trainings_on_profile_id", using: :btree
    t.index ["user_id"], name: "index_trainings_on_user_id", using: :btree
  end

  create_table "user_docs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "doc_type"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.boolean  "verified"
    t.text     "notes",              limit: 65535
    t.datetime "deleted_at"
    t.boolean  "expired"
    t.integer  "created_by_user_id"
    t.boolean  "not_available"
    t.index ["deleted_at"], name: "index_user_docs_on_deleted_at", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                                                              default: "email", null: false
    t.string   "uid",                                                                   default: "",      null: false
    t.string   "encrypted_password",                                                    default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                         default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "role",                          limit: 20
    t.string   "nurse_type",                    limit: 20
    t.text     "tokens",                        limit: 65535
    t.datetime "created_at",                                                                              null: false
    t.datetime "updated_at",                                                                              null: false
    t.string   "sex",                           limit: 1
    t.string   "phone",                         limit: 15
    t.text     "address",                       limit: 65535
    t.string   "languages"
    t.integer  "pref_commute_distance"
    t.string   "occupation",                    limit: 20
    t.string   "speciality",                    limit: 100
    t.integer  "experience"
    t.string   "referal_code",                  limit: 10
    t.boolean  "accept_terms"
    t.integer  "care_home_id"
    t.boolean  "active"
    t.text     "image_url",                     limit: 65535
    t.string   "sort_code",                     limit: 6
    t.string   "bank_account",                  limit: 8
    t.boolean  "verified"
    t.datetime "auto_selected_date"
    t.decimal  "lat",                                         precision: 18, scale: 15
    t.decimal  "lng",                                         precision: 18, scale: 15
    t.string   "postcode",                      limit: 10
    t.integer  "total_rating"
    t.integer  "rating_count"
    t.text     "push_token",                    limit: 65535
    t.datetime "deleted_at"
    t.string   "unsubscribe_hash"
    t.boolean  "subscription"
    t.date     "verified_on"
    t.date     "verification_reminder"
    t.string   "locale",                        limit: 8
    t.boolean  "phone_verified"
    t.boolean  "accept_bank_transactions"
    t.datetime "accept_bank_transactions_date"
    t.string   "sms_verification_code",         limit: 5
    t.string   "title"
    t.boolean  "ready_for_verification"
    t.index ["care_home_id"], name: "index_users_on_care_home_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
    t.index ["unsubscribe_hash"], name: "index_users_on_unsubscribe_hash", using: :btree
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
