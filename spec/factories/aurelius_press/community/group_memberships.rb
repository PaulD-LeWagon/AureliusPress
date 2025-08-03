# == Schema Information
#
# Table name: aurelius_press_group_memberships
#
#  id            :bigint           not null, primary key
#  group_id      :bigint           not null
#  user_id       :bigint           not null
#  role          :integer          default("member"), not null
#  status        :integer          default("active"), not null
#  invited_by_id :bigint
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :aurelius_press_community_group_membership, class: "AureliusPress::Community::GroupMembership" do
    # Associate with a group and a user
    association :group, factory: :aurelius_press_community_group, strategy: :build
    association :user, factory: :aurelius_press_user, strategy: :build

    # Default enum values
    role { :member }
    status { :active }

    # Optional: traits for different roles and statuses
    trait :moderator do
      role { :moderator }
    end

    trait :admin do
      role { :admin }
    end

    trait :pending_invite do
      status { :pending_invite_acceptance }
      # If you need to specify who invited them:
      association :invited_by, factory: :aurelius_press_user
      message { "Come join our super cool group!" }
    end

    trait :pending_request do
      status { :pending_request_approval }
      message { "I'd love to join this group!" }
    end

    trait :rejected do
      status { :rejected }
    end
  end
end
