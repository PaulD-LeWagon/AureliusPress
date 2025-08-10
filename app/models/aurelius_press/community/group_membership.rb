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
class AureliusPress::Community::GroupMembership < ApplicationRecord
  self.table_name = "aurelius_press_group_memberships"

  belongs_to :group, class_name: "AureliusPress::Community::Group"
  belongs_to :user, class_name: "AureliusPress::User"
  belongs_to :invited_by, class_name: "AureliusPress::User", optional: true

  enum :role, %i[
         member
         moderator
         admin
       ]

  enum :status, %i[
         active
         pending_invite_acceptance
         pending_request_approval
         rejected
         inactive
       ]

  validates :group_id, uniqueness: { scope: :user_id, message: "User is already a member of this group." }
  validates :role, presence: true
  validates :status, presence: true
  validates :invited_by, presence: true, if: :pending_invite_acceptance?
end
