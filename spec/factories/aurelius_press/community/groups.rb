# == Schema Information
#
# Table name: aurelius_press_groups
#
#  id              :bigint           not null, primary key
#  slug            :string           not null
#  name            :string           not null
#  description     :text
#  creator_id      :bigint           not null
#  status          :integer          default("active"), not null
#  privacy_setting :integer          default("private_group"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :aurelius_press_community_group, class: "AureliusPress::Community::Group" do
    # Ensure a unique name for each group created
    sequence(:name) { |n| "#{Faker::Lorem.words(number: 3).join(" ")} #{n}" }
    # Generate a slug from the name - this assumes Sluggable module handles it
    description { "A fantastic group for sharing ideas and content." }
    # Associate with a creator (an AureliusPress::User)
    # This assumes you have a factory for :aurelius_press_user
    association :creator, factory: :aurelius_press_user, strategy: :create

    # Default enum values
    status { :active }
    privacy_setting { :public_group } # Or :private_group, depending on desired default

    # Optional: traits for different types of groups
    trait :private_group do
      privacy_setting { :private_group }
    end

    trait :hidden_group do
      privacy_setting { :hidden_group }
    end

    trait :archived do
      status { :archived }
    end
  end
end
