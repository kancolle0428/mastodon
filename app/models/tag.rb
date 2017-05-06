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

  HASHTAG_RE = /(?:^|[^\/\)\w])#([[:word:]_]*[[:alpha:]_][[:word:]_]*)/i

  validates :name, presence: true, uniqueness: true

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
