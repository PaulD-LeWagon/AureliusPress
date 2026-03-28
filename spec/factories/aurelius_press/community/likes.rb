FactoryBot.define do
  factory :aurelius_press_community_like, class: "AureliusPress::Community::Like" do
    association :user, factory: :aurelius_press_user
    association :likeable, factory: :aurelius_press_catalogue_quote

    state { :no_reaction }

    trait :like_state do
      state { :like }
    end

    trait :dislike_state do
      state { :dislike }
    end

    trait :no_reaction_state do
      state { :no_reaction }
    end
  end
end
