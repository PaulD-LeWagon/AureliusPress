class ContentBlock < ApplicationRecord
  belongs_to :document
  # Add default_scope { order(:position) } for ordered retrieval
  default_scope { order(:position) }
  # Add uniqueness validation for position within a document:
  validates :position, presence: true, uniqueness: { scope: :document_id }
  # Validate html_id uniqueness within the same document (HTML IDs should be unique across the entire page)
  # Allow nil/blank as ID is optional, but if present, must be unique for that document
  # Add format validation for valid HTML ID characters
  validates :html_id, uniqueness: { scope: :document_id, allow_blank: true },
                      format: { with: /\A[a-zA-Z][a-zA-Z0-9\-_:]*\z/, message: "must start with a letter and contain only letters, numbers, hyphens, underscores, or colons", allow_blank: true }

  # No specific validations for html_class or data_attributes at the model level for now,
  # as they are flexible by design. Data_attributes will always be a hash due to the default.
end
