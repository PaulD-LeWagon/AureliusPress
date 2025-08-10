# == Schema Information
#
# Table name: aurelius_press_taggings
#
#  id          :bigint           not null, primary key
#  document_id :bigint           not null
#  tag_id      :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AureliusPress::Taxonomy::Tagging < ApplicationRecord
  self.table_name = "aurelius_press_taggings"
  belongs_to :document, class_name: "AureliusPress::Document::Document"
  belongs_to :tag, class_name: "AureliusPress::Taxonomy::Tag"

  validates :document, presence: true
  validates :tag, presence: true
  validates :tag_id, uniqueness: {
                       scope: :document_id,
                       message: "already applied to this document",
                     }
end
