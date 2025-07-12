class RichTextBlock < ApplicationRecord
  belongs_to :content_block
  has_rich_text :content
end
