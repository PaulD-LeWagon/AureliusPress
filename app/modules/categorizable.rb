module Categorizable
  extend ActiveSupport::Concern

  included do
    has_one :categorization, as: :categorizable, class_name: "AureliusPress::Taxonomy::Categorization", dependent: :destroy
    has_one :category, through: :categorization, source: :category
    accepts_nested_attributes_for :categorization, reject_if: :all_blank, allow_destroy: true
  end
end
