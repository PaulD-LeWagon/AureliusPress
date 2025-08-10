# == Schema Information
#
# Table name: aurelius_press_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AureliusPress::Taxonomy::Tag < ApplicationRecord
  self.table_name = "aurelius_press_tags"
  has_many :taggings, dependent: :destroy, class_name: "AureliusPress::Taxonomy::Tagging"
  has_many :documents, through: :taggings, class_name: "AureliusPress::Document::Document"
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug = name.parameterize if name.present? && slug.blank?
  end
end
