module Categorizable
  extend ActiveSupport::Concern

  included do
    has_many :categorizations, as: :categorizable, class_name: "AureliusPress::Taxonomy::Categorization", dependent: :destroy
    has_many :categories, through: :categorizations, source: :category
    accepts_nested_attributes_for :categorizations, reject_if: :all_blank, allow_destroy: true
  end
end
