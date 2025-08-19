# == Schema Information
#
# Table name: aurelius_press_image_blocks
#
#  id          :bigint           not null, primary key
#  caption     :string
#  alignment   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  link_text   :string
#  link_title  :string
#  link_class  :string
#  link_target :string
#  link_url    :string
#
class AureliusPress::ContentBlock::ImageBlock < ApplicationRecord

  self.table_name = "aurelius_press_image_blocks"

  include ::Contentable

  has_one_attached :image

  enum :alignment, [
    :left,
    :right,
    :center,
    :full_width,
    :float_left,
    :float_right,
  ], default: :float_left

  public

  def to_partial_path
    "aurelius_press/admin/content_block/image_blocks/image_block"
  end
end
