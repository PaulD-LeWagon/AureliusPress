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
require "rails_helper"

RSpec.describe AureliusPress::Community::Like, type: :model do
  let(:user) { create(:aurelius_press_user) }
  let(:document) { create(:aurelius_press_document_blog_post) }

  subject { create(:aurelius_press_community_like, user: user, likeable: document) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likeable) }
    it { should validate_presence_of(:state) }

    it "validates uniqueness of user per item" do
      create(:aurelius_press_community_like, user: user, likeable: document)
      duplicate = build(:aurelius_press_community_like, user: user, likeable: document)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("You have already voted on this item.")
    end
  end

  describe "enums" do
    it { should define_enum_for(:state).with_values(neutral: 0, like: 1, dislike: 2) }
  end

  describe "scopes" do
    let!(:like) { create(:aurelius_press_community_like, :like_state, user: create(:aurelius_press_user), likeable: document) }
    let!(:dislike) { create(:aurelius_press_community_like, :dislike_state, user: create(:aurelius_press_user), likeable: document) }
    let!(:neutral) { create(:aurelius_press_community_like, :neutral_state, user: create(:aurelius_press_user), likeable: document) }

    it "filtes by likes" do
      expect(described_class.likes).to include(like)
      expect(described_class.likes).not_to include(dislike)
    end

    it "filters by dislikes" do
      expect(described_class.dislikes).to include(dislike)
      expect(described_class.dislikes).not_to include(like)
    end
  end
end
