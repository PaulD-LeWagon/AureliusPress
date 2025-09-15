# == Schema Information
#
# Table name: aurelius_press_fragments
#
#  id               :bigint           not null, primary key
#  type             :string           not null
#  user_id          :bigint           not null
#  commentable_type :string
#  commentable_id   :bigint
#  title            :string
#  position         :integer          default(0), not null
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  notable_type     :string
#  notable_id       :bigint
#
class AureliusPress::Fragment::Comment < AureliusPress::Fragment::Fragment
  # Inherits from Fragment, so it can use all Fragment's features
  # and also has its own specific behavior for comments.

  # Attributes: inherited from Fragment
  # [Required] - type: string, used for Single Table Inheritance (STI)
  # [Required] - status: enum, representing the document's status (draft, published, archived)
  # [Required] - visibility: enum, representing who can see the document (private_to_owner, etc.)
  # [Required] - content: text, rich text content for documents that support it

  # Associations @see Fragment
  # A Comment can be on any document type through polymorphic association.
  belongs_to :commentable, polymorphic: true
  # A comment can have many replies (nested comments)
  has_many :replies, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable

  # Action Text @see Fragment

  # Validations
  validate :commentable_type_is_allowed
  validates :type, inclusion: { in: [self.name], message: ">>> must be a valid comment type." }

  # # Scopes can be added here if needed, e.g., by user, by commentable type, etc.
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  def to_s
    "Comment: #{content.body.to_plain_text.truncate(30)} by #{user&.full_name}"
  end

  private

  def commentable_type_is_allowed
    commentable_types = [
      AureliusPress::Document::Document.namespaced_commentable_types,
      AureliusPress::Fragment::Fragment.namespaced_commentable_types,
      "AureliusPress::Catalogue::Author",
      "AureliusPress::Catalogue::Source",
      "AureliusPress::Catalogue::Quote",
    ].flatten
    unless commentable_types.include?(commentable_type)
      # Allowed types are: #{commentable_types.join(", ")}."
      errors.add(:commentable_type, "[#{commentable_type}] is not a commentable document type.")
    end
  end

  def set_defaults
    self.status ||= :draft # Default status for comments
    self.visibility ||= :private_to_owner # Default visibility for comments
  end
end
