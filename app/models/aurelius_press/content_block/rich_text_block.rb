# == Schema Information
#
# Table name: aurelius_press_rich_text_blocks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AureliusPress::ContentBlock::RichTextBlock < ApplicationRecord
  self.table_name = "aurelius_press_rich_text_blocks"
  has_one :content_block, as: :contentable, touch: true, dependent: :destroy
  has_rich_text :body

  validates :content_block, presence: true
  validate :validate_body_presence

  private

  def validate_body_presence
    errors.add(:body, "can't be blank") if body.blank?
  end
end
