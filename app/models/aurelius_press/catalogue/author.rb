# == Schema Information
#
# Table name: aurelius_press_authors
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  slug             :string           not null
#  bio              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
class AureliusPress::Catalogue::Author < ApplicationRecord
  self.table_name = "aurelius_press_authors"

  include Sluggable

  # Associations
  has_many :authorships, class_name: "AureliusPress::Catalogue::Authorship", dependent: :destroy, inverse_of: :author
  has_many :sources, through: :authorships, source: :source, inverse_of: :authors
  has_many :quotes, through: :sources, source: :quotes
  has_many :affiliate_links, as: :linkable, class_name: "AureliusPress::Catalogue::AffiliateLink", dependent: :destroy, inverse_of: :linkable

  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable

  # Validations
  validates :name, presence: true

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :with_quotes, -> { joins(:quotes).distinct }
  scope :with_affiliate_links, -> { joins(:affiliate_links).distinct }

  # Instance Methods
  def to_param; self.slug; end

  def bio_summary
    bio.truncate(100) if bio.present?
  end
end
