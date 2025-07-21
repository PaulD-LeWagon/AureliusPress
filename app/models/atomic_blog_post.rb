# AtomicBlogPost model inheriting from Document
# This model represents a simple blog post with a rich text content block and a
# single attached image file (old skool!).
class AtomicBlogPost < Document
  # Associations @see Document model for common associations
  # has_many :comments, dependent: :destroy
  # has_many :likes, dependent: :destroy
  # Optional: Add tags and categories associations if needed
  # Uncomment the following lines if you plan to implement tagging and categorization later
  # has_many :taggings, dependent: :destroy
  # has_many :categorizations, dependent: :destroy
  # has_many :tags (via Tagging join table - to be created later)
  # has_many :categories (via Categorization join table - to be created later)

  # Action Text & Active Storage
  has_rich_text :content
  has_one_attached :document_file

  validates :content, presence: true
  validate :correct_document_file_type, if: -> { document_file.attached? }

  # Callbacks
  # Automatically set default visibility and published_at if not provided
  # This is done in the after_initialize callback to ensure it applies to new records
  # and does not override existing values.
  after_initialize :set_defaults, if: :new_record?

  def published?
    # Check if the post is published based on the presence and value of published_at
    published_at.present? && published_at <= Time.current
  end

  private

  def set_defaults
    self.visibility ||= :public_to_www
    self.published_at ||= Time.current if published?
  end

  def correct_document_file_type
    # Only run this validation if a document_file is actually attached
    if document_file.attached?
      # Define the MIME types you consider suitable images
      allowed_types = %w[image/png image/jpeg image/webp image/gif image/svg+xml]
      # Check if the attached file's content_type is NOT in the allowed list
      unless allowed_types.include?(document_file.content_type)
        # Add an error to the :document_file attribute
        errors.add(:document_file, "must be a PNG, JPEG, WebP, GIF, or SVG image.")
      end
    end
  end
end
