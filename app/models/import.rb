# frozen_string_literal: true
# == Schema Information
#
# Table name: imports
#
#  id                :integer          not null, primary key
#  account_id        :integer          not null
#  type              :integer          not null
#  approved          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#

class Import < ApplicationRecord
  FILE_TYPES = ['text/plain', 'text/csv'].freeze

  self.inheritance_column = false

  belongs_to :account, required: true

  enum type: [:following, :blocking, :muting]

  validates :type, presence: true

  has_attached_file :data, url: '/system/:hash.:extension', hash_secret: ENV['PAPERCLIP_SECRET']
  validates_attachment_content_type :data, content_type: FILE_TYPES
end
