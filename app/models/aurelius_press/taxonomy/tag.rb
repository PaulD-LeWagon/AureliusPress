# == Schema Information
#
# Table name: aurelius_press_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AureliusPress::Taxonomy::Tag < ApplicationRecord

  include Sluggable
  slugged_by :name

  self.table_name = "aurelius_press_tags"

  has_many :taggings, dependent: :destroy, class_name: "AureliusPress::Taxonomy::Tagging"
  has_many :taggables, through: :taggings, source: :taggable
  # Specific document type associations
  has_many :atomic_blog_posts, through: :taggings, source: :taggable, source_type: "AureliusPress::Document::AtomicBlogPost"
  has_many :blog_posts, through: :taggings, source: :taggable, source_type: "AureliusPress::Document::BlogPost"
  has_many :pages, through: :taggings, source: :taggable, source_type: "AureliusPress::Document::Page"
  has_many :quotes, through: :taggings, source: :taggable, source_type: "AureliusPress::Catalogue::Quote"
  has_many :sources, through: :taggings, source: :taggable, source_type: "AureliusPress::Catalogue::Source"


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
