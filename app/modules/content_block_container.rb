module ContentBlockContainer
  extend ActiveSupport::Concern

  included do
    # Delegated Types automatically adds scopes to access specific types!
    # E.g., document.content_blocks.image_blocks will return only image blocks
    # document.content_blocks.rich_text_blocks will return only rich text blocks
    has_many :content_blocks, dependent: :destroy, inverse_of: :document, class_name: "AureliusPress::ContentBlock::ContentBlock"
    # Nested attributes for content blocks and category
    accepts_nested_attributes_for :content_blocks, reject_if: :all_blank, allow_destroy: true
  end
end
