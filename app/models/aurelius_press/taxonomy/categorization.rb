# == Schema Information
#
# Table name: aurelius_press_categorizations
#
#  id               :bigint           not null, primary key
#  category_id      :bigint           not null
#  categorizable_id   :bigint           not null
#  categorizable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class AureliusPress::Taxonomy::Categorization < ApplicationRecord
  self.table_name = "aurelius_press_categorizations"

  # Associations
  belongs_to :category, class_name: "AureliusPress::Taxonomy::Category", inverse_of: :categorizations
  belongs_to :categorizable, polymorphic: true

  accepts_nested_attributes_for :category, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :category, presence: true
  validates :categorizable, presence: true
  validates :category_id, uniqueness: { scope: [:categorizable_id, :categorizable_type], message: "already assigned to this record" }
end
