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

  include ::Contentable

  has_rich_text :content

  validate :validate_content_presence

  public
  
  def to_partial_path
    "aurelius_press/admin/content_block/rich_text_blocks/rich_text_block"
  end

  private

  def validate_content_presence
    errors.add(:content, "can't be blank") if content.blank?
  end
end
