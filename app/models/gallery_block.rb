class GalleryBlock < ApplicationRecord
  belongs_to :content_block
  has_many_attached :images
  enum :layout_type, [:grid, :carousel, :masonry], default: :carousel
end
