class AureliusPress::Catalogue::Quote < ApplicationRecord
  self.table_name = "aurelius_press_quotes"

  include Sluggable
  # Tell Sluggable to use the 'sluggable_text' method as source,
  # but to watch the 'text' column for changes.
  slugged_by :sluggable_text, watches: :text

  # Associations
  belongs_to :source, class_name: "AureliusPress::Catalogue::Source", inverse_of: :quotes
  belongs_to :original_quote, class_name: "AureliusPress::Catalogue::Quote", optional: true
  has_many :variants, class_name: "AureliusPress::Catalogue::Quote", foreign_key: :original_quote_id

  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable

  # Helper to get authors of the quote's source e.g. (a_quote.source_authors)
  delegate :authors, to: :source, prefix: true, allow_nil: true

  # Validations
  validates :text, presence: true
  validates :source, presence: true

  def to_param
    self.slug
  end

  private

  def sluggable_text
    # Ensure it's never blank, append ID if text is blank for uniqueness
    self.text.blank? ? "quote-#{id || SecureRandom.hex(4)}" : self.text[0..29] # Truncate to 30 characters
  end
end
