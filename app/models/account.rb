# frozen_string_literal: true
# == Schema Information
#
# Table name: accounts
#
#  id                      :integer          not null, primary key
#  username                :string(255)      default(""), not null
#  domain                  :string(255)
#  secret                  :string(255)      default(""), not null
#  private_key             :text(65535)
#  public_key              :text(65535)
#  remote_url              :string(255)      default(""), not null
#  salmon_url              :string(255)      default(""), not null
#  hub_url                 :string(255)      default(""), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  note                    :text(65535)
#  display_name            :string(255)      default(""), not null
#  uri                     :string(255)      default(""), not null
#  url                     :string(255)
#  avatar_file_name        :string(255)
#  avatar_content_type     :string(255)
#  avatar_file_size        :integer
#  avatar_updated_at       :datetime
#  header_file_name        :string(255)
#  header_content_type     :string(255)
#  header_file_size        :integer
#  header_updated_at       :datetime
#  avatar_remote_url       :string(255)
#  subscription_expires_at :datetime
#  silenced                :boolean          default(FALSE), not null
#  suspended               :boolean          default(FALSE), not null
#  locked                  :boolean          default(FALSE), not null
#  header_remote_url       :string(255)      default(""), not null
#  statuses_count          :integer          default(0), not null
#  followers_count         :integer          default(0), not null
#  following_count         :integer          default(0), not null
#  last_webfingered_at     :datetime
#

class Account < ApplicationRecord
  MENTION_RE = /(?:^|[^\/\w])@([a-z0-9_]+(?:@[a-z0-9\.\-]+[a-z0-9]+)?)/i

  include AccountAvatar
  include AccountHeader
  include Attachmentable
  include Targetable

  # Local users
  has_one :user, inverse_of: :account
  validates :username, presence: true, format: { with: /\A[a-z0-9_]+\z/i }, uniqueness: { scope: :domain, case_sensitive: false }, length: { maximum: 30 }, if: 'local?'
  validates :username, presence: true, uniqueness: { scope: :domain, case_sensitive: true }, unless: 'local?'

  # Local user profile validations
  validates :display_name, length: { maximum: 30 }, if: 'local?'
  validates :note, length: { maximum: 160 }, if: 'local?'

  # Timelines
  has_many :stream_entries, inverse_of: :account, dependent: :destroy
  has_many :statuses, inverse_of: :account, dependent: :destroy
  has_many :favourites, inverse_of: :account, dependent: :destroy
  has_many :mentions, inverse_of: :account, dependent: :destroy
  has_many :notifications, inverse_of: :account, dependent: :destroy

  # Follow relations
  has_many :follow_requests, dependent: :destroy

  has_many :active_relationships,  class_name: 'Follow', foreign_key: 'account_id',        dependent: :destroy
  has_many :passive_relationships, class_name: 'Follow', foreign_key: 'target_account_id', dependent: :destroy

  has_many :following, -> { order('follows.id desc') }, through: :active_relationships,  source: :target_account
  has_many :followers, -> { order('follows.id desc') }, through: :passive_relationships, source: :account

  # Block relationships
  has_many :block_relationships, class_name: 'Block', foreign_key: 'account_id', dependent: :destroy
  has_many :blocking, -> { order('blocks.id desc') }, through: :block_relationships, source: :target_account
  has_many :blocked_by_relationships, class_name: 'Block', foreign_key: :target_account_id, dependent: :destroy
  has_many :blocked_by, -> { order('blocks.id desc') }, through: :blocked_by_relationships, source: :account

  # Mute relationships
  has_many :mute_relationships, class_name: 'Mute', foreign_key: 'account_id', dependent: :destroy
  has_many :muting, -> { order('mutes.id desc') }, through: :mute_relationships, source: :target_account

  # Media
  has_many :media_attachments, dependent: :destroy

  # PuSH subscriptions
  has_many :subscriptions, dependent: :destroy

  # Report relationships
  has_many :reports
  has_many :targeted_reports, class_name: 'Report', foreign_key: :target_account_id

  scope :remote, -> { where.not(domain: nil) }
  scope :local, -> { where(domain: nil) }
  scope :without_followers, -> { where(followers_count: 0) }
  scope :with_followers, -> { where('followers_count > 0') }
  scope :expiring, ->(time) { where(subscription_expires_at: nil).or(where('subscription_expires_at < ?', time)).remote.with_followers }
  scope :partitioned, -> { order(:id) }
  scope :silenced, -> { where(silenced: true) }
  scope :suspended, -> { where(suspended: true) }
  scope :recent, -> { reorder(id: :desc) }
  scope :alphabetic, -> { order(domain: :asc, username: :asc) }
  scope :by_domain_accounts, -> { group(:domain).select(:domain, 'COUNT(*) AS accounts_count').order('accounts_count desc') }

  delegate :email,
           :current_sign_in_ip,
           :current_sign_in_at,
           :confirmed?,
           to: :user,
           prefix: true,
           allow_nil: true

  delegate :allowed_languages, to: :user, prefix: false, allow_nil: true

  def follow!(other_account)
    active_relationships.where(target_account: other_account).first_or_create!(target_account: other_account)
  end

  def block!(other_account)
    block_relationships.where(target_account: other_account).first_or_create!(target_account: other_account)
  end

  def mute!(other_account)
    mute_relationships.where(target_account: other_account).first_or_create!(target_account: other_account)
  end

  def unfollow!(other_account)
    follow = active_relationships.find_by(target_account: other_account)
    follow&.destroy
  end

  def unblock!(other_account)
    block = block_relationships.find_by(target_account: other_account)
    block&.destroy
  end

  def unmute!(other_account)
    mute = mute_relationships.find_by(target_account: other_account)
    mute&.destroy
  end

  def following?(other_account)
    following.include?(other_account)
  end

  def blocking?(other_account)
    blocking.include?(other_account)
  end

  def muting?(other_account)
    muting.include?(other_account)
  end

  def requested?(other_account)
    follow_requests.where(target_account: other_account).exists?
  end

  def local?
    domain.nil?
  end

  def acct
    local? ? username : "#{username}@#{domain}"
  end

  def local_username_and_domain
    "#{username}@#{Rails.configuration.x.local_domain}"
  end

  def to_webfinger_s
    "acct:#{local_username_and_domain}"
  end

  def subscribed?
    subscription_expires_at.present?
  end

  def followers_domains
    followers.reorder(nil).pluck('distinct accounts.domain')
  end

  def favourited?(status)
    status.proper.favourites.where(account: self).count.positive?
  end

  def reblogged?(status)
    status.proper.reblogs.where(account: self).count.positive?
  end

  def keypair
    private_key.nil? ? OpenSSL::PKey::RSA.new(public_key) : OpenSSL::PKey::RSA.new(private_key)
  end

  def subscription(webhook_url)
    OStatus2::Subscription.new(remote_url, secret: secret, lease_seconds: 86_400 * 30, webhook: webhook_url, hub: hub_url)
  end

  def save_with_optional_media!
    save!
  rescue ActiveRecord::RecordInvalid
    self.avatar              = nil
    self.header              = nil
    self[:avatar_remote_url] = ''
    self[:header_remote_url] = ''
    save!
  end

  def object_type
    :person
  end

  def to_param
    username
  end

  def excluded_from_timeline_account_ids
    Rails.cache.fetch("exclude_account_ids_for:#{id}") { blocking.pluck(:target_account_id) + blocked_by.pluck(:account_id) + muting.pluck(:target_account_id) }
  end

  class << self
    def find_local!(username)
      find_remote!(username, nil)
    end

    def find_remote!(username, domain)
      return if username.blank?
      where('lower(accounts.username) = ?', username.downcase).where(domain.nil? ? { domain: nil } : 'lower(accounts.domain) = ?', domain&.downcase).take!
    end

    def find_local(username)
      find_local!(username)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def find_remote(username, domain)
      find_remote!(username, domain)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def triadic_closures(account, limit = 5)
      sql = <<-SQL.squish
        WITH first_degree AS (
            SELECT target_account_id
            FROM follows
            WHERE account_id = :account_id
          )
        SELECT accounts.*
        FROM follows
        INNER JOIN accounts ON follows.target_account_id = accounts.id
        WHERE account_id IN (SELECT * FROM first_degree) AND target_account_id NOT IN (SELECT * FROM first_degree) AND target_account_id <> :account_id
        GROUP BY target_account_id, accounts.id
        ORDER BY count(account_id) DESC
        LIMIT :limit
      SQL

      find_by_sql(
        [sql, { account_id: account.id, limit: limit }]
      )
    end

    def search_for(terms, limit = 10)
      terms = "%#{terms}%"
      Account.where("display_name LIKE ? OR username LIKE ? OR domain LIKE ?", terms, terms, terms)
             .limit(limit)
    end

    def advanced_search_for(terms, account, limit = 10)
      terms = "%#{terms}%"
      Account.where("display_name LIKE ? OR username LIKE ? OR domain LIKE ?", terms, terms, terms)
             .limit(limit)
    end

    def following_map(target_account_ids, account_id)
      follow_mapping(Follow.where(target_account_id: target_account_ids, account_id: account_id), :target_account_id)
    end

    def followed_by_map(target_account_ids, account_id)
      follow_mapping(Follow.where(account_id: target_account_ids, target_account_id: account_id), :account_id)
    end

    def blocking_map(target_account_ids, account_id)
      follow_mapping(Block.where(target_account_id: target_account_ids, account_id: account_id), :target_account_id)
    end

    def muting_map(target_account_ids, account_id)
      follow_mapping(Mute.where(target_account_id: target_account_ids, account_id: account_id), :target_account_id)
    end

    def requested_map(target_account_ids, account_id)
      follow_mapping(FollowRequest.where(target_account_id: target_account_ids, account_id: account_id), :target_account_id)
    end

    private

    def follow_mapping(query, field)
      query.pluck(field).each_with_object({}) { |id, mapping| mapping[id] = true }
    end
  end

  before_create :generate_keys
  before_validation :normalize_domain

  private

  def generate_keys
    return unless local?

    keypair = OpenSSL::PKey::RSA.new(Rails.env.test? ? 1024 : 2048)
    self.private_key = keypair.to_pem
    self.public_key  = keypair.public_key.to_pem
  end

  def normalize_domain
    return if local?

    self.domain = TagManager.instance.normalize_domain(domain)
  end
end
