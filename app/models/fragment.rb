class Fragment < ApplicationRecord
  # This class represents a fragment of content that can be associated with documents.
  # It is designed to be flexible and can be used for various purposes, such as storing
  # reusable content snippets or sections of a document.

  # Attributes:
  # [Required] type: string, used for Single Table Inheritance (STI)
  # [Required] user: references, the user who created the fragment
  # [Required] commentable: references{polymorphic}, allows fragments to be associated with different document types
  # [Required] status: enum, representing the fragment's status (draft, published, archived)
  # [Required] visibility: enum, representing who can see the fragment (private_to_owner, etc.)
  # [Required] content: text, rich text content for fragments that support it
  # [Optional] title: text, the title of the fragment
  # [Optional] position: integer, for ordering fragments within a document

  # STI (Single Table Inheritance) setup
  self.inheritance_column = :type

  def self.polymorphic_name
    # Returns the name of the document type for polymorphic associations
    # e.g., "Note", "Comment", etc. and Not "Fragment"
    name
  end

  # Enums
  enum :status, [:draft, :published, :archived]
  enum :visibility, [:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]

  # Associations
  # A Fragment subclass belongs to a user (the author of the fragment)
  belongs_to :user

  # Action Text
  has_rich_text :content

  # Validations
  validates :type, presence: true
  validates :user, presence: true
  validates :content, presence: true
  validates :status, presence: true
  validates :visibility, presence: true

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.status ||= :draft # Default status for fragments
    self.visibility ||= :private_to_owner # Default visibility for fragments
  end
end
