# == Schema Information
#
# Table name: aurelius_press_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AureliusPress::Taxonomy::Category < ApplicationRecord
  self.table_name = "aurelius_press_categories"
  # This model represents a category for blog posts or documents.
  # It includes a name and a slug for URL-friendly identification.

  # Attributes:
  # - name: string, the name of the category
  # - slug: string, a URL-friendly version of the name

  # Concerns
  include Sluggable
  slugged_by :name

  # Associations
  has_many :documents, dependent: :destroy, class_name: "AureliusPress::Document::Document", inverse_of: :category

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end
