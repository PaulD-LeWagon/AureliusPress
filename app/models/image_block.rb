class ImageBlock < ApplicationRecord
  belongs_to :content_block
  has_one_attached :image
  enum :alignment, [
    :left,
    :right,
    :center,
    :full_width,
    :float_left,
    :float_right,
  ], default: :float_left
end
