class Category < ApplicationRecord
  # This model represents a category for blog posts or documents.
  # It includes a name and a slug for URL-friendly identification.

  # Attributes:
  # - name: string, the name of the category
  # - slug: string, a URL-friendly version of the name

  # Callbacks
  before_validation :generate_slug, on: :create

  # Associations
  has_many :documents

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  private

  def generate_slug
    self.slug = name.parameterize if name.present? && slug.blank?
  end
end
