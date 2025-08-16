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
  has_rich_text :content

  validates :content_block, presence: true
  validate :validate_content_presence

  private

  def validate_content_presence
    errors.add(:content, "can't be blank") if content.blank?
  end
end
