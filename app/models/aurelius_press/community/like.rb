# == Schema Information
#
# Table name: aurelius_press_likes
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  likeable_type :string           not null
#  likeable_id   :bigint           not null
#  state         :integer          default("neutral"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class AureliusPress::Community::Like < ApplicationRecord
  self.table_name = "aurelius_press_likes"

  # Associations
  belongs_to :user, class_name: "AureliusPress::User"
  belongs_to :likeable, polymorphic: true, touch: true

  # Enums
  enum :state, { neutral: 0, like: 1, dislike: 2 }, default: :neutral

  # Validations
  validates :user_id, presence: true, uniqueness: { scope: [ :likeable_type, :likeable_id ], message: "You have already voted on this item." }
  validates :likeable, presence: true
  validates :state, presence: true

  # Scopes
  scope :likes, -> { where(state: :like) }
  scope :dislikes, -> { where(state: :dislike) }
  scope :neutral, -> { where(state: :neutral) }
end
