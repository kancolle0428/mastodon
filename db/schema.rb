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

ActiveRecord::Schema.define(version: 20170425202925) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "username",                              default: "",    null: false
    t.string   "domain"
    t.string   "secret",                                default: "",    null: false
    t.text     "private_key",             limit: 65535
    t.text     "public_key",              limit: 65535
    t.string   "remote_url",                            default: "",    null: false
    t.string   "salmon_url",                            default: "",    null: false
    t.string   "hub_url",                               default: "",    null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.text     "note",                    limit: 65535
    t.string   "display_name",                          default: "",    null: false
    t.string   "uri",                                   default: "",    null: false
    t.string   "url"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "header_file_name"
    t.string   "header_content_type"
    t.integer  "header_file_size"
    t.datetime "header_updated_at"
    t.string   "avatar_remote_url"
    t.datetime "subscription_expires_at"
    t.boolean  "silenced",                              default: false, null: false
    t.boolean  "suspended",                             default: false, null: false
    t.boolean  "locked",                                default: false, null: false
    t.string   "header_remote_url",                     default: "",    null: false
    t.integer  "statuses_count",                        default: 0,     null: false
    t.integer  "followers_count",                       default: 0,     null: false
    t.integer  "following_count",                       default: 0,     null: false
    t.datetime "last_webfingered_at"
    t.index ["url"], name: "index_accounts_on_url", using: :btree
    t.index ["username", "domain"], name: "index_accounts_on_username_and_domain", unique: true, using: :btree
  end

  create_table "blocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",        null: false
    t.integer  "target_account_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["account_id", "target_account_id"], name: "index_blocks_on_account_id_and_target_account_id", unique: true, using: :btree
  end

  create_table "domain_blocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "domain",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "severity",     default: 0
    t.boolean  "reject_media"
    t.index ["domain"], name: "index_domain_blocks_on_domain", unique: true, using: :btree
  end

  create_table "favourites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id", null: false
    t.integer  "status_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "status_id"], name: "index_favourites_on_account_id_and_status_id", unique: true, using: :btree
    t.index ["status_id"], name: "index_favourites_on_status_id", using: :btree
  end

  create_table "follow_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",        null: false
    t.integer  "target_account_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["account_id", "target_account_id"], name: "index_follow_requests_on_account_id_and_target_account_id", unique: true, using: :btree
  end

  create_table "follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",        null: false
    t.integer  "target_account_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["account_id", "target_account_id"], name: "index_follows_on_account_id_and_target_account_id", unique: true, using: :btree
  end

  create_table "imports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",        null: false
    t.integer  "type",              null: false
    t.boolean  "approved"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  create_table "media_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint   "status_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "remote_url",        default: "", null: false
    t.integer  "account_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "shortcode"
    t.integer  "type",              default: 0,  null: false
    t.json     "file_meta"
    t.index ["shortcode"], name: "index_media_attachments_on_shortcode", unique: true, using: :btree
    t.index ["status_id"], name: "index_media_attachments_on_status_id", using: :btree
  end

  create_table "mentions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id"
    t.bigint   "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "status_id"], name: "index_mentions_on_account_id_and_status_id", unique: true, using: :btree
    t.index ["status_id"], name: "index_mentions_on_status_id", using: :btree
  end

  create_table "mutes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",        null: false
    t.integer  "target_account_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["account_id", "target_account_id"], name: "index_mutes_on_account_id_and_target_account_id", unique: true, using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id"
    t.bigint   "activity_id"
    t.string   "activity_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "from_account_id"
    t.index ["account_id", "activity_id", "activity_type"], name: "account_activity", unique: true, using: :btree
    t.index ["activity_id", "activity_type"], name: "index_notifications_on_activity_id_and_activity_type", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "resource_owner_id",               null: false
    t.integer  "application_id",                  null: false
    t.string   "token",                           null: false
    t.integer  "expires_in",                      null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                                       null: false
    t.string   "uid",                                        null: false
    t.string   "secret",                                     null: false
    t.text     "redirect_uri", limit: 65535,                 null: false
    t.string   "scopes",                     default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "superapp",                   default: false, null: false
    t.string   "website"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "preview_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint   "status_id"
    t.string   "url",                              default: "", null: false
    t.string   "title"
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "type",                             default: 0,  null: false
    t.text     "html",               limit: 65535
    t.string   "author_name",                      default: "", null: false
    t.string   "author_url",                       default: "", null: false
    t.string   "provider_name",                    default: "", null: false
    t.string   "provider_url",                     default: "", null: false
    t.integer  "width",                            default: 0,  null: false
    t.integer  "height",                           default: 0,  null: false
    t.index ["status_id"], name: "index_preview_cards_on_status_id", unique: true, using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id",                                               null: false
    t.integer  "target_account_id",                                        null: false
    t.bigint   "status_ids",                               default: 0,     null: false
    t.text     "comment",                    limit: 65535
    t.boolean  "action_taken",                             default: false, null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "action_taken_by_account_id"
    t.index ["account_id"], name: "index_reports_on_account_id", using: :btree
    t.index ["target_account_id"], name: "index_reports_on_target_account_id", using: :btree
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "var",                      null: false
    t.text     "value",      limit: 65535
    t.string   "thing_type"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "uri"
    t.integer  "account_id",                                           null: false
    t.text     "text",                   limit: 65535
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.bigint   "in_reply_to_id"
    t.integer  "reblog_of_id"
    t.string   "url"
    t.boolean  "sensitive",                            default: false
    t.integer  "visibility",                           default: 0,     null: false
    t.integer  "in_reply_to_account_id"
    t.integer  "application_id"
    t.text     "spoiler_text",           limit: 65535
    t.boolean  "reply",                                default: false
    t.integer  "favourites_count",                     default: 0,     null: false
    t.integer  "reblogs_count",                        default: 0,     null: false
    t.string   "language",                             default: "en",  null: false
    t.index ["account_id"], name: "index_statuses_on_account_id", using: :btree
    t.index ["in_reply_to_id"], name: "index_statuses_on_in_reply_to_id", using: :btree
    t.index ["reblog_of_id"], name: "index_statuses_on_reblog_of_id", using: :btree
    t.index ["uri"], name: "index_statuses_on_uri", unique: true, using: :btree
  end

  create_table "statuses_tags", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint  "status_id", null: false
    t.integer "tag_id",    null: false
    t.index ["status_id"], name: "index_statuses_tags_on_status_id", using: :btree
    t.index ["tag_id", "status_id"], name: "index_statuses_tags_on_tag_id_and_status_id", unique: true, using: :btree
  end

  create_table "stream_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "account_id"
    t.bigint   "activity_id"
    t.string   "activity_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "hidden",        default: false, null: false
    t.index ["account_id"], name: "index_stream_entries_on_account_id", using: :btree
    t.index ["activity_id", "activity_type"], name: "index_stream_entries_on_activity_id_and_activity_type", using: :btree
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "callback_url",                default: "",    null: false
    t.string   "secret"
    t.datetime "expires_at"
    t.boolean  "confirmed",                   default: false, null: false
    t.integer  "account_id",                                  null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "last_successful_delivery_at"
    t.index ["callback_url", "account_id"], name: "index_subscriptions_on_callback_url_and_account_id", unique: true, using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "email",                     default: "",    null: false
    t.integer  "account_id",                                null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "encrypted_password",        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                     default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "locale"
    t.string   "encrypted_otp_secret"
    t.string   "encrypted_otp_secret_iv"
    t.string   "encrypted_otp_secret_salt"
    t.integer  "consumed_timestep"
    t.boolean  "otp_required_for_login"
    t.datetime "last_emailed_at"
    t.string   "otp_backup_codes"
    t.string   "allowed_languages"
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
    t.index ["allowed_languages"], name: "index_users_on_allowed_languages", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "web_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_web_settings_on_user_id", unique: true, using: :btree
  end

  add_foreign_key "statuses", "statuses", column: "reblog_of_id", on_delete: :cascade
end
