# frozen_string_literal: true
# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  has_and_belongs_to_many :statuses

  HASHTAG_NAME_RE = '[[:word:]_]*[[:alpha:]_][[:word:]_]*'
  HASHTAG_RE = /(?:^|[^\/\)\w])#(#{HASHTAG_NAME_RE})/i

  validates :name, presence: true, uniqueness: true, format: { with: /\A#{HASHTAG_NAME_RE}\z/i }

  def to_param
    name
  end

  class << self
    def search_for(terms, limit = 5)
      terms = "%#{terms}%"
      Tag.where("name LIKE ?", terms)
         .limit(limit)
    end
  end
end
