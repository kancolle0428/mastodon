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

ActiveRecord::Schema.define(version: 20170720000000) do

  create_table "account_domain_blocks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "domain"], name: "index_account_domain_blocks_on_account_id_and_domain", unique: true
  end

  create_table "accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "username", default: "", null: false
    t.string "domain"
    t.string "secret", default: "", null: false
    t.text "private_key"
    t.text "public_key"
    t.string "remote_url", default: "", null: false
    t.string "salmon_url", default: "", null: false
    t.string "hub_url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.string "display_name", default: "", null: false
    t.string "uri", default: "", null: false
    t.string "url"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "header_file_name"
    t.string "header_content_type"
    t.integer "header_file_size"
    t.datetime "header_updated_at"
    t.string "avatar_remote_url"
    t.datetime "subscription_expires_at"
    t.boolean "silenced", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.boolean "locked", default: false, null: false
    t.string "header_remote_url", default: "", null: false
    t.integer "statuses_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.integer "following_count", default: 0, null: false
    t.datetime "last_webfingered_at"
    t.string "inbox_url", default: "", null: false
    t.string "outbox_url", default: "", null: false
    t.string "shared_inbox_url", default: "", null: false
    t.string "followers_url", default: "", null: false
    t.integer "protocol", default: 0, null: false
    t.index ["uri"], name: "index_accounts_on_uri"
    t.index ["url"], name: "index_accounts_on_url"
    t.index ["username", "domain"], name: "index_accounts_on_username_and_domain", unique: true
  end

  create_table "blocks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "target_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "target_account_id"], name: "index_blocks_on_account_id_and_target_account_id", unique: true
    t.index ["target_account_id"], name: "fk_rails_009e331529"
  end

  create_table "conversation_mutes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.bigint "conversation_id", null: false
    t.index ["account_id", "conversation_id"], name: "index_conversation_mutes_on_account_id_and_conversation_id", unique: true
  end

  create_table "conversations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uri"], name: "index_conversations_on_uri", unique: true
  end

  create_table "domain_blocks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "domain", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "severity", default: 0
    t.boolean "reject_media", default: false, null: false
    t.index ["domain"], name: "index_domain_blocks_on_domain", unique: true
  end

  create_table "favourites", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "id"], name: "index_favourites_on_account_id_and_id"
    t.index ["account_id", "status_id"], name: "index_favourites_on_account_id_and_status_id", unique: true
    t.index ["status_id"], name: "index_favourites_on_status_id"
  end

  create_table "follow_requests", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "target_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "target_account_id"], name: "index_follow_requests_on_account_id_and_target_account_id", unique: true
    t.index ["target_account_id"], name: "fk_rails_972b9f1173"
  end

  create_table "follows", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "target_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "target_account_id"], name: "index_follows_on_account_id_and_target_account_id", unique: true
    t.index ["target_account_id"], name: "fk_rails_ac4936d17b"
  end

  create_table "imports", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "type", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "data_file_name"
    t.string "data_content_type"
    t.integer "data_file_size"
    t.datetime "data_updated_at"
    t.index ["account_id"], name: "fk_rails_138d41de18"
  end

  create_table "media_attachments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "status_id"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.string "remote_url", default: "", null: false
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shortcode"
    t.integer "type", default: 0, null: false
    t.json "file_meta"
    t.index ["account_id"], name: "index_media_attachments_on_account_id"
    t.index ["shortcode"], name: "index_media_attachments_on_shortcode", unique: true
    t.index ["status_id"], name: "index_media_attachments_on_status_id"
  end

  create_table "mentions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "status_id"], name: "index_mentions_on_account_id_and_status_id", unique: true
    t.index ["status_id"], name: "index_mentions_on_status_id"
  end

  create_table "mutes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "target_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "target_account_id"], name: "index_mutes_on_account_id_and_target_account_id", unique: true
    t.index ["target_account_id"], name: "fk_rails_802b245a68"
  end

  create_table "notifications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.bigint "activity_id"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_account_id"
    t.index ["account_id", "activity_id", "activity_type"], name: "account_activity", unique: true
    t.index ["activity_id", "activity_type"], name: "index_notifications_on_activity_id_and_activity_type"
    t.index ["from_account_id"], name: "fk_rails_a9df2835a1"
  end

  create_table "oauth_access_grants", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "fk_rails_b4b53e07b8"
    t.index ["resource_owner_id"], name: "fk_rails_330c32d8d9"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["application_id"], name: "fk_rails_732cb83ab7"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "superapp", default: false, null: false
    t.string "website"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "preview_cards", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "status_id"
    t.string "url", default: "", null: false
    t.string "title"
    t.string "description"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type", default: 0, null: false
    t.text "html"
    t.string "author_name", default: "", null: false
    t.string "author_url", default: "", null: false
    t.string "provider_name", default: "", null: false
    t.string "provider_url", default: "", null: false
    t.integer "width", default: 0, null: false
    t.integer "height", default: 0, null: false
    t.index ["status_id"], name: "index_preview_cards_on_status_id", unique: true
  end

  create_table "reports", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id", null: false
    t.integer "target_account_id", null: false
    t.bigint "status_ids", default: 0, null: false
    t.text "comment"
    t.boolean "action_taken", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "action_taken_by_account_id"
    t.index ["account_id"], name: "index_reports_on_account_id"
    t.index ["action_taken_by_account_id"], name: "fk_rails_e8e172880e"
    t.index ["target_account_id"], name: "index_reports_on_target_account_id"
  end

  create_table "session_activations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id", null: false
    t.string "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent", default: "", null: false
    t.string "ip"
    t.integer "access_token_id"
    t.integer "web_push_subscription_id"
    t.index ["access_token_id"], name: "fk_rails_a0d14b4784"
    t.index ["session_id"], name: "index_session_activations_on_session_id", unique: true
    t.index ["user_id"], name: "index_session_activations_on_user_id"
  end

  create_table "settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "var", null: false
    t.text "value"
    t.string "thing_type"
    t.integer "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "statuses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "uri"
    t.integer "account_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "in_reply_to_id"
    t.integer "reblog_of_id"
    t.string "url"
    t.boolean "sensitive", default: false, null: false
    t.integer "visibility", default: 0, null: false
    t.integer "in_reply_to_account_id"
    t.integer "application_id"
    t.text "spoiler_text"
    t.boolean "reply", default: false, null: false
    t.integer "favourites_count", default: 0, null: false
    t.integer "reblogs_count", default: 0, null: false
    t.string "language"
    t.bigint "conversation_id"
    t.index ["account_id", "id"], name: "index_statuses_on_account_id_id"
    t.index ["conversation_id"], name: "index_statuses_on_conversation_id"
    t.index ["in_reply_to_account_id"], name: "fk_rails_5904f5f441"
    t.index ["in_reply_to_id"], name: "index_statuses_on_in_reply_to_id"
    t.index ["reblog_of_id"], name: "index_statuses_on_reblog_of_id"
    t.index ["uri"], name: "index_statuses_on_uri", unique: true
  end

  create_table "statuses_tags", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "status_id", null: false
    t.bigint "tag_id", null: false
    t.index ["status_id"], name: "index_statuses_tags_on_status_id"
    t.index ["tag_id", "status_id"], name: "index_statuses_tags_on_tag_id_and_status_id", unique: true
  end

  create_table "stream_entries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.bigint "activity_id"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.index ["account_id"], name: "index_stream_entries_on_account_id"
    t.index ["activity_id", "activity_type"], name: "index_stream_entries_on_activity_id_and_activity_type"
  end

  create_table "subscriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "callback_url", default: "", null: false
    t.string "secret"
    t.datetime "expires_at"
    t.boolean "confirmed", default: false, null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_successful_delivery_at"
    t.string "domain"
    t.index ["account_id", "callback_url"], name: "index_subscriptions_on_account_id_and_callback_url", unique: true
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", default: "", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "admin", default: false, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "locale"
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login", default: false, null: false
    t.datetime "last_emailed_at"
    t.string "otp_backup_codes"
    t.string "filtered_languages", default: "", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["filtered_languages"], name: "index_users_on_filtered_languages"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "web_push_subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "endpoint", null: false
    t.string "key_p256dh", null: false
    t.string "key_auth", null: false
    t.text "data", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "web_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_web_settings_on_user_id", unique: true
  end

  add_foreign_key "account_domain_blocks", "accounts", on_delete: :cascade
  add_foreign_key "blocks", "accounts", column: "target_account_id", on_delete: :cascade
  add_foreign_key "blocks", "accounts", on_delete: :cascade
  add_foreign_key "conversation_mutes", "accounts", on_delete: :cascade
  add_foreign_key "favourites", "accounts", on_delete: :cascade
  add_foreign_key "favourites", "statuses", on_delete: :cascade
  add_foreign_key "follow_requests", "accounts", column: "target_account_id", on_delete: :cascade
  add_foreign_key "follow_requests", "accounts", on_delete: :cascade
  add_foreign_key "follows", "accounts", column: "target_account_id", on_delete: :cascade
  add_foreign_key "follows", "accounts", on_delete: :cascade
  add_foreign_key "imports", "accounts", on_delete: :cascade
  add_foreign_key "media_attachments", "accounts", on_delete: :nullify
  add_foreign_key "mentions", "accounts", on_delete: :cascade
  add_foreign_key "mutes", "accounts", column: "target_account_id", on_delete: :cascade
  add_foreign_key "mutes", "accounts", on_delete: :cascade
  add_foreign_key "notifications", "accounts", column: "from_account_id", on_delete: :cascade
  add_foreign_key "notifications", "accounts", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id", on_delete: :cascade
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id", on_delete: :cascade
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id", on_delete: :cascade
  add_foreign_key "reports", "accounts", column: "action_taken_by_account_id", on_delete: :nullify
  add_foreign_key "reports", "accounts", column: "target_account_id", on_delete: :cascade
  add_foreign_key "reports", "accounts", on_delete: :cascade
  add_foreign_key "session_activations", "oauth_access_tokens", column: "access_token_id", on_delete: :cascade
  add_foreign_key "session_activations", "users", on_delete: :cascade
  add_foreign_key "statuses", "accounts", column: "in_reply_to_account_id", on_delete: :nullify
  add_foreign_key "statuses", "accounts", on_delete: :cascade
  add_foreign_key "statuses", "statuses", column: "reblog_of_id", on_delete: :cascade
  add_foreign_key "stream_entries", "accounts", on_delete: :cascade
  add_foreign_key "subscriptions", "accounts", on_delete: :cascade
  add_foreign_key "users", "accounts", on_delete: :cascade
  add_foreign_key "web_settings", "users", on_delete: :cascade
end
