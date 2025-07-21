class ContentBlock < ApplicationRecord
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

  ## Associations
  # Each content block belongs to a document
  belongs_to :document

  # The key line for Delegated Types: defines the types it can "delegate" to
  delegated_type :contentable, types: TYPES, dependent: :destroy, inverse_of: :content_block

  # Polymorphic associations for comments, likes
  # has_many :likes, as: :likeable, dependent: :destroy, inverse_of: :likeable
  # Polymorphic association for notes, allowing users to add notes to content blocks
  has_many :notes, as: :notable, dependent: :destroy, inverse_of: :notable

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
end
