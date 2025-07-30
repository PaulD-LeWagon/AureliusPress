class AureliusPress::Catalogue::Source < ApplicationRecord
  self.table_name = "aurelius_press_sources"

  include Sluggable
  # Callbacks
  slugged_by :title

  # Associations
  has_many :authorships, class_name: "AureliusPress::Catalogue::Authorship", dependent: :destroy, inverse_of: :source
  has_many :authors, through: :authorships, source: :author, inverse_of: :sources
  has_many :quotes, class_name: "AureliusPress::Catalogue::Quote", dependent: :destroy, inverse_of: :source
  has_many :affiliate_links, as: :linkable, dependent: :destroy, inverse_of: :linkable

  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable

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
