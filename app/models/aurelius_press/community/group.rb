class AureliusPress::Community::Group < ApplicationRecord
  self.table_name = "aurelius_press_groups"

  include Sluggable

  # Associations
  belongs_to :creator, class_name: "AureliusPress::User"
  has_many :group_memberships, class_name: "AureliusPress::Community::GroupMembership", dependent: :destroy
  has_many :members, through: :group_memberships, source: :user # Alias for clarity (users in the group)
  has_and_belongs_to_many :documents, class_name: "AureliusPress::Document::Document",
                                      join_table: "aurelius_press_documents_aurelius_press_groups",
                                      foreign_key: "aurelius_press_group_id",
                                      association_foreign_key: "aurelius_press_document_id"
  has_one_attached :image

  # Enums for status and privacy
  enum :status, %i[
         active
         pending_approval
         archived
         suspended
       ], default: :active

  enum :privacy_setting, %i[
         public_group
         private_group
         hidden_group
       ], default: :private_group

  # Validations
  validates :name, presence: true, uniqueness: { case_insensitive: true }, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :creator, presence: true
  validates :status, presence: true
  validates :privacy_setting, presence: true

  # Add any custom image validations here if desired (e.g., content_type, size)
end
