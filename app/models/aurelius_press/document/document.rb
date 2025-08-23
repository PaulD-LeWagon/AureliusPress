# == Schema Information
#
# Table name: aurelius_press_documents
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  category_id      :bigint
#  type             :string           not null
#  slug             :string           not null
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
class AureliusPress::Document::Document < ApplicationRecord
  self.table_name = "aurelius_press_documents"
  # This class uses Single Table Inheritance (STI) to allow different types of
  # documents to be stored in the same table. Subclasses like Page,
  # AtomicBlogPost, BlogPost, and JournalEntry will inherit from this class.
  # Note: Comment and Note are no longer direct subclasses of Document. They are
  # now subclasses of the Fragment model.

  # The Document model is designed to be flexible and extensible, allowing for
  # various document types with shared functionality.

  # Attributes:
  # - [Required] type: string, used for Single Table Inheritance (STI)
  # - [Required] title: string, the title of the document
  # - [Required] slug: string, a URL-friendly version of the title (auto-generated))
  # - [Required] user: references, the user who created the document

  # - [Optional] status: enum, representing the document's status (default: draft)
  # - [Optional] visibility: enum, representing who can see the document (default: private_to_owner)
  # - [Optional] subtitle: string, a short descriptive subtitle
  # - [Optional] category: references, the category the document belongs to
  # - [Optional] published_at: datetime, the date when the document was published (optional)
  # - [Optional] comments_enabled: boolean, whether comments are allowed on the document (default: false)

  include Sluggable
  slugged_by :title

  # STI (Single Table Inheritance) setup
  self.inheritance_column = :type
  # This allows subclasses to be stored in the same table with a 'type' column
  # The 'type' column will be used to determine the subclass of the document.
  def self.polymorphic_name
    # Returns the name of the document type for polymorphic associations
    # e.g., "BlogPost", "JournalEntry", "AtomicBlogPost" and Not "Document"
    name
  end

  # Document type constants
  TYPES = %w[Page AtomicBlogPost BlogPost JournalEntry]
  # Namespaced types for polymorphic associations
  NAMESPACED_TYPES = TYPES.map { |type| "AureliusPress::Document::#{type}" }
  # Commentable types for polymorphic association
  NAMESPACED_COMMENTABLE_TYPES = (TYPES - %w[Page]).map { |type| "AureliusPress::Document::#{type}" }
  # Enums
  enum :status, [:draft, :published, :scheduled, :archived, :in_review, :trashed]
  enum :visibility, [:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]

  # Callbacks
  after_initialize :set_defaults, if: :new_record?
  before_validation :set_published_at, if: :will_be_published?
  before_validation :clear_published_at, if: :will_be_draft?

  # Associations
  belongs_to :user, class_name: "AureliusPress::User"

  # Taxonomy associations
  belongs_to :category, class_name: "AureliusPress::Taxonomy::Category", optional: true # A Document CAN have a Category
  has_many :taggings, dependent: :destroy, class_name: "AureliusPress::Taxonomy::Tagging"
  has_many :tags, through: :taggings, class_name: "AureliusPress::Taxonomy::Tag"

  # Delegated Types automatically adds scopes to access specific types!
  # E.g., document.content_blocks.image_blocks will return only image blocks
  # document.content_blocks.rich_text_blocks will return only rich text blocks
  has_many :content_blocks, dependent: :destroy, inverse_of: :document, class_name: "AureliusPress::ContentBlock::ContentBlock"
  accepts_nested_attributes_for :content_blocks, reject_if: :all_blank, allow_destroy: true
  # A Document can have many comments (and replies) if they are enabled
  # This is a polymorphic association, allowing comments on different document
  # types.
  #
  # For example, a comment can be on a BlogPost, Page, JournalEntry, etc. or
  # even another Comment. This allows for nested comments, where a comment can
  # have replies. The commentable type is determined by the 'type' column in the
  # comments table. This allows for flexibility in associating comments with
  # different document types.
  has_many :comments, as: :commentable, class_name: "AureliusPress::Fragment::Comment", dependent: :destroy, inverse_of: :commentable
  has_many :notes, as: :notable, class_name: "AureliusPress::Fragment::Note", dependent: :destroy, inverse_of: :notable
  has_many :likes, as: :likeable, class_name: "AureliusPress::Community::Like", dependent: :destroy, inverse_of: :likeable
  has_and_belongs_to_many :groups,
                          class_name: "AureliusPress::Community::Group",
                          join_table: "aurelius_press_documents_aurelius_press_groups",
                          foreign_key: "aurelius_press_document_id",
                          association_foreign_key: "aurelius_press_group_id"
  # Validations
  validates :type, presence: true, inclusion: { in: NAMESPACED_TYPES, message: "must be a valid document type." }
  validates :title, presence: true
  validates :status, presence: true
  validates :visibility, presence: true
  validates :category, presence: true, if: -> { category_id.present? }
  validates :user, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :published, -> { where(status: :published) }
  scope :archived, -> { where(status: :archived) }
  scope :draft, -> { where(status: :draft) }
  scope :by_status, ->(status) { where(status: status) if status.present? }

  scope :by_visibility, ->(visibility) { where(visibility: visibility) if visibility.present? }
  scope :by_type, ->(type) { where(type: type) if type.present? }
  scope :by_title, ->(title) { where("title ILIKE ?", "%#{title}%") if title.present? }
  scope :by_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) if tag_name.present? }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }

  # Class Methods
  def self.namespaced_commentable_types
    # Returns the namespaced commentable types for polymorphic associations
    # This includes all document types that can have comments
    NAMESPACED_COMMENTABLE_TYPES
  end

  def self.namespaced_types
    # Returns the namespaced types for this Document model
    NAMESPACED_TYPES
  end

  def self.document_types
    # Returns the document types
    TYPES
  end

  # Instance Methods
  def to_s
    title || "Document ##{id}"
  end

  # Returns the URL-friendly slug for the document
  def to_param; self.slug; end

  private

  def set_published_at
    self.published_at ||= Time.current
  end

  def clear_published_at
    self.published_at = nil
  end

  def will_be_published?
    status_changed? && status == 'published'
  end

  def will_be_draft?
    status_changed? && status == 'draft'
  end

  def set_defaults
    self.visibility ||= :private_to_owner
    self.status ||= :draft
  end
end
