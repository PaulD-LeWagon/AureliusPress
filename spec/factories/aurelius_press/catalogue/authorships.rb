FactoryBot.define do
  factory :aurelius_press_catalogue_authorship, class: "AureliusPress::Catalogue::Authorship" do
    association :author, factory: :aurelius_press_catalogue_author
    association :source, factory: :aurelius_press_catalogue_source

    role { :author } # Default role, can be overridden in tests

    trait :co_author do
      role { :co_author }
    end

    trait :editor do
      role { :editor }
    end

    trait :translator do
      role { :translator }
    end

    trait :commentator do
      role { :commentator }
    end

    trait :compiler do
      role { :compiler }
    end

    trait :introducer do
      role { :introducer }
    end

    trait :contributor do
      role { :contributor }
    end
  end
end
