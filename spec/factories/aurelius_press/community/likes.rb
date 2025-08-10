# == Schema Information
#
# Table name: aurelius_press_likes
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  likeable_type :string           not null
#  likeable_id   :bigint           not null
#  emoji         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# spec/factories/likes.rb
FactoryBot.define do
  factory :aurelius_press_community_like, class: "AureliusPress::Community::Like" do
    # Associations
    association :user, factory: :aurelius_press_user
    # Polymorphic Association: likeable
    association :likeable, factory: :aurelius_press_catalogue_quote, strategy: :create

    # Enum for emoji reaction
    emoji { :thumbs_up }

    # Traits for specific emojis
    trait :with_heart do
      emoji { :heart }
    end

    trait :with_shocked_face do
      emoji { :shocked_face }
    end

    trait :with_sad_face do
      emoji { :sad_face }
    end

    trait :with_angry_face do
      emoji { :angry_face }
    end
  end
end
