# == Schema Information
#
# Table name: aurelius_press_content_blocks
#
#  id               :bigint           not null, primary key
#  document_id      :bigint           not null
#  contentable_type :string           not null
#  contentable_id   :bigint           not null
#  position         :integer          default(0), not null
#  html_id          :string
#  html_class       :string
#  data_attributes  :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class AureliusPress::ContentBlock::ContentBlock < ApplicationRecord
  self.table_name = "aurelius_press_content_blocks"
  # ContentBlock model represents a block of content within a Document
  # It uses Delegated Types to allow different types of content blocks
  # such as RichText, Image, Video, etc.

  # ContentBlock types (delegated types)
  # These are the types of content blocks that can be created
  # Each type corresponds to a specific content block implementation
  TYPES = %w[
    RichTextBlock
    ImageBlock
    GalleryBlock
    VideoEmbedBlock
  ].freeze

  # AudioBlock
  # CodeBlock
  # LinkBlock
  # QuoteBlock

  TYPES.each do |type_name|
    scope type_name.underscore.pluralize.to_sym, -> {
            where(contentable_type: "AureliusPress::ContentBlock::#{type_name}")
          }
  end

  def self.get_namespaced_types
    TYPES.map { |type| "AureliusPress::ContentBlock::#{type}" }
  end

  ## Associations
  # Each content block belongs to a document
  belongs_to :document, class_name: "AureliusPress::Document::Document"

  # The key line for Delegated Types: defines the types it can "delegate" to
  delegated_type :contentable, types: self.get_namespaced_types, dependent: :destroy, inverse_of: :content_block

  # Polymorphic associations for comments, likes
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable
  # Polymorphic association for notes, allowing users to add notes to content blocks
  has_many :notes, as: :notable, class_name: "AureliusPress::Fragment::Note", dependent: :destroy, inverse_of: :notable

  ## Validations
  # Validate presence of document association
  validates :document, presence: true
  # Add uniqueness validation for position within a document:
  validates :position,
    presence: true,
    uniqueness: { scope: :document_id },
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
    }
  # Validate html_id uniqueness within the same document (HTML IDs should be unique across the entire page)
  # Allow nil/blank as ID is optional, but if present, must be unique for that document
  # Add format validation for valid HTML ID characters
  validates :html_id, uniqueness: { scope: :document_id, allow_blank: true },
                      format: {
                        with: /\A[a-zA-Z][a-zA-Z0-9\-_:]*\z/,
                        message: "must start with a letter and contain only \
                          letters, numbers, hyphens, underscores, or colons",
                        allow_blank: true,
                      }
  # Add default_scope { order(:position) } for ordered retrieval
  default_scope { order(:position) }

  # Instance method to return the contentable type name
  def contentable_type_name
    contentable.class.name.demodulize.underscore
  end

  # Instance method to return the contentable type class
  def contentable_type_class
    contentable.class
  end
end
