module Contentable
  extend ActiveSupport::Concern
  included do
    has_one :content_block, as: :contentable, touch: true, dependent: :destroy, inverse_of: :contentable
    validates :content_block, presence: true
  end
end
