class Document < ApplicationRecord
  # Include the necessary modules for rich text and file attachments
  # include ActionText::Attachable
  # include ActiveStorage::Attached::Model

  # Attributes
  # attr_reader :title, :slug, :type, :status, :visibility

  # Callbacks
  after_initialize :set_default_visibility, if: :new_record?
  after_initialize :set_default_status, if: :new_record?
  before_validation :generate_slug, on: :create

  # Action Text & Active Storage
  has_rich_text :content
  has_one_attached :document_file # Or has_many_attached :document_files

  # Associations
  belongs_to :user
  belongs_to :category, optional: true # A Document can optionally belong to a Category
  has_many :content_blocks, dependent: :destroy # Cascade delete content blocks
  has_many :taggings, dependent: :destroy # Cascade delete taggings
  has_many :tags, through: :taggings


  # STI (Single Table Inheritance) setup
  # self.inheritance_column = :type
  # Enums
  enum :status, [:draft, :published, :archived]
  enum :visibility, [:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]
  # Document type constants
  DOCUMENT_TYPES = %w[Page BlogPost JournalEntry Note Comment].freeze

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :archived, -> { where(status: :archived) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_visibility, ->(visibility) { where(visibility: visibility) if visibility.present? }

  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :type, presence: true # Ensures STI subclass is set
  validates :status, presence: true, inclusion: { in: statuses.values }
  validates :visibility, presence: true, inclusion: { in: visibilities.values }
  validates :type, inclusion: { in: DOCUMENT_TYPES }

  def set_default_visibility
    self.visibility ||= :private_to_owner
  end

  def set_default_status
    self.status ||= :draft
  end

  private

  def generate_slug
    self.slug = title.parameterize if title.present? && slug.blank?
  end
end
