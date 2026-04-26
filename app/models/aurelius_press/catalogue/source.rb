# == Schema Information
#
# Table name: aurelius_press_sources
#
#  id               :bigint           not null, primary key
#  title            :string
#  slug             :string
#  description      :text
#  source_type      :integer
#  date             :date
#  isbn             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
class AureliusPress::Catalogue::Source < ApplicationRecord
  self.table_name = "aurelius_press_sources"

  include Categorizable
  include Taggable
  include Sluggable
  # Callbacks
  slugged_by :title

  # Associations
  has_many :authorships, class_name: "AureliusPress::Catalogue::Authorship", dependent: :destroy, inverse_of: :source
  has_many :authors, through: :authorships, source: :author, inverse_of: :sources
  has_many :quotes, class_name: "AureliusPress::Catalogue::Quote", dependent: :destroy, inverse_of: :source
  has_many :affiliate_links, as: :linkable, dependent: :destroy, inverse_of: :linkable
  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable
  has_many :notes, as: :notable, class_name: "AureliusPress::Fragment::Note", dependent: :destroy, inverse_of: :notable
  has_many :reactions, as: :reactable, class_name: "AureliusPress::Community::Reaction", dependent: :destroy, inverse_of: :reactable
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable
  # Active Storage association
  has_one_attached :cover_image
  # Nested (embedded forms) attributes
  accepts_nested_attributes_for :authorships, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :affiliate_links, reject_if: :all_blank, allow_destroy: true

  # Scopes
  scope :ordered_by_title, -> { order(:title) }
  scope :ordered_by_type, -> { order(:source_type) }

  enum :source_type, %i[
         book
         play
         poem
         manuscript
         journal
         letter
         article
         essay
         thesis
         speech
         lecture
         interview
         dialogue
         statute
         decree
         website
         email
         newsletter
         review
         blog
         vlog
         podcast
       ], default: :book

  # Validations
  validates :title, presence: true
  validates :date, presence: true

  def to_param
    self.slug
  end
end
