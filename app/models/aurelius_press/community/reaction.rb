# == Schema Information
#
# Table name: aurelius_press_reactions
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  reactable_type :string           not null
#  reactable_id   :bigint           not null
#  emoji          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class AureliusPress::Community::Reaction < ApplicationRecord
  self.table_name = "aurelius_press_reactions"
  # Associations
  belongs_to :user
  belongs_to :reactable, polymorphic: true, touch: true

  # Enums for the emoji reactions
  enum :emoji, [
    :thumbs_up, # Default if none specified
    :heart,
    :rolling_on_the_floor_laughing,
    :clapping_hands,
    :thinking_face,
    :shocked_face,
    :sad_face,
    :angry_face,
    :fire,
    :eyes,
    :party_popper,
    :raised_hands,
    :star_struck,
  ], default: :thumbs_up

  # Validations
  validates :reactable_id, presence: true
  validates :reactable_type, presence: true
  validates :emoji, presence: true # Although default is set, explicit presence is good
  validates :emoji, inclusion: { in: emojis.keys, message: "%{value} is not a valid reaction" }

  validates :user_id,
            presence: true,
            uniqueness: {
              scope: [:reactable_type, :reactable_id],
              message: "You have already reacted to this item.",
            }
end
