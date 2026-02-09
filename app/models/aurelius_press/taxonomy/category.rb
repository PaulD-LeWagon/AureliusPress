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
  has_many :categorizations, class_name: "AureliusPress::Taxonomy::Categorization", dependent: :destroy, inverse_of: :category
  has_many :categorizables, through: :categorizations, source: :categorizable
  # has_many :documents, dependent: :destroy, class_name: "AureliusPress::Document::Document", inverse_of: :cate# Specific document type associations
  has_many :blog_posts, through: :categorizations, source: :categorizable, source_type: "AureliusPress::Document::BlogPost"
  has_many :atomic_blog_posts, through: :categorizations, source: :categorizable, source_type: "AureliusPress::Document::AtomicBlogPost"
  has_many :pages, through: :categorizations, source: :categorizable, source_type: "AureliusPress::Document::Page"
  has_many :quotes, through: :categorizations, source: :categorizable, source_type: "AureliusPress::Catalogue::Quote"
  has_many :sources, through: :categorizations, source: :categorizable, source_type: "AureliusPress::Catalogue::Source"
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :ordered, -> { order(:name) }

  # Instance Methods
  def to_param
    slug
  end

  def to_s
    name
  end
end
