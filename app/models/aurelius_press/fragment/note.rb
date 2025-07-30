class AureliusPress::Fragment::Note < AureliusPress::Fragment::Fragment
  # Inherits from Fragment, so it can use all Fragment's features
  # and also has its own specific behavior for notes.

  # Attributes: inherited from Fragment
  # [Optional] - title: string, the title of the note (optional)
  # [Required] - type: string, used for Single Table Inheritance (STI)
  # [Required] - status: enum, representing the document's status (draft, published, archived)
  # [Required] - visibility: enum, representing who can see the document (private_to_owner, etc.)
  # [Required] - content: text, rich text content for documents that support it

  # Associations @see Fragment
  # A note belongs to a user (the author of the note) @see Fragment
  # A Fragment subclass can be on any document type through polymorphic association.
  belongs_to :notable, polymorphic: true
  # A note can have comments (and or replies) if they are public and enabled
  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable

  # Action Text @see Fragment

  # Validations @see Fragment
  validates :type, inclusion: { in: [self.name] }

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Scopes
  scope :visible_to_owner, ->(user) { where(user: user, visibility: :private_to_owner) }
  scope :visible_to_group, ->(user) { where(user: user, visibility: :private_to_group) }
  scope :visible_to_app_users, ->(user) { where(user: user, visibility: :private_to_app_users) }
  scope :visible_to_public, ->(user) { where(user: user, visibility: :public_to_www) }
  scope :public_to_www, ->(user) { where(user: user, visibility: :public_to_www) }

  # Methods
  def to_s
    title.presence || "Note ##{id}"
  end

  private

  def set_defaults
    # Notes are always private visibility, initially
    self.status ||= :draft # Default status for notes
    # Notes are private by default, but can be changed later
    self.visibility ||= :private_to_owner
  end
end
