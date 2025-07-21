class Tagging < ApplicationRecord
  belongs_to :document
  belongs_to :tag
  validates :document, presence: true
  validates :tag, presence: true
  validates :tag_id, uniqueness: {
             scope: :document_id,
             message: "already applied to this document",
           }
end
