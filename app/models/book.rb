# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  name            :string
#  slug            :string
#  creator_id      :integer
#  status          :string
#  privacy_setting :string
#  alt_title       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Book < ApplicationRecord # Ensure it inherits from ApplicationRecord
  include Sluggable
  # slugged_by :name

  belongs_to :creator, class_name: "AureliusPress::User", foreign_key: "creator_id", optional: true

  # Add validations needed for your Book model
  # The concern should handle slug validation, but we keep these as a sanity check.
  validates :name, presence: true
  validates :creator_id, presence: true
  validates :status, presence: true
  validates :privacy_setting, presence: true

  # validates :slug, presence: true
  # validates :slug, uniqueness: { case_insensitive: true }

  enum status: { draft: "draft", active: "active", archived: "archived" }
  enum privacy_setting: { public_group: "public_group", private_group: "private_group" }
end
