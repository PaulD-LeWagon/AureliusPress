class ImageBlock < ApplicationRecord
  has_one :content_block, as: :contentable, touch: true, dependent: :destroy
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
