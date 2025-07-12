class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :documents, through: :taggings # A Tag has many Documents through Tagging
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  # Add callback for slug generation if desired
end
