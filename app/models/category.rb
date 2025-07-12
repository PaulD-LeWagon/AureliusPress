class Category < ApplicationRecord
  # Attributes
  attr_accessor :name, :slug

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
