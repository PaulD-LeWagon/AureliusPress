# == Schema Information
#
# Table name: aurelius_press_taggings
#
#  id            :bigint           not null, primary key
#  tag_id        :bigint           not null
#  taggable_id   :bigint           not null
#  taggable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class AureliusPress::Taxonomy::Tagging < ApplicationRecord
  self.table_name = "aurelius_press_taggings"
  belongs_to :tag, class_name: "AureliusPress::Taxonomy::Tag"
  belongs_to :taggable, polymorphic: true

  validates :tag, presence: true
  validates :taggable, presence: true
  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type], message: "already applied to this record" }
end
