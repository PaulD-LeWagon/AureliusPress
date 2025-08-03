# == Schema Information
#
# Table name: aurelius_press_gallery_blocks
#
#  id          :bigint           not null, primary key
#  layout_type :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AureliusPress::ContentBlock::GalleryBlock < ApplicationRecord
  self.table_name = "aurelius_press_gallery_blocks"
  has_one :content_block, as: :contentable, touch: true, dependent: :destroy
  has_many_attached :images
  enum :layout_type, [
    :grid,
    :carousel,
    :masonry,
  ], default: :carousel

  # Additional validations can be added here
  validate :validate_images_presence

  private

  def validate_images_presence
    errors.add(:images, "must have at least one image") if images.empty?
  end
end
