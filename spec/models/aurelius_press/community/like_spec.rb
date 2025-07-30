# spec/models/like_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Community::Like, type: :model do
  # Factories
  let(:user) { create(:aurelius_press_user) }
  let(:document) { create(:aurelius_press_document_blog_post) }
  # Subject for basic valid state
  # Default emoji is thumbs_up but set it explicitly for clarity
  subject { create(:aurelius_press_community_like, user: user, likeable: document, emoji: :thumbs_up) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe "class validations" do
    # Presence validations
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likeable_id) }
    it { should validate_presence_of(:likeable_type) }
    it { should validate_presence_of(:emoji) }

    # Enum validation
    it {
      should define_enum_for(:emoji)
               .with_values([
                 :thumbs_up,
                 :heart,
                 :shocked_face,
                 :sad_face,
                 :angry_face,
               ])
               .with_default(:thumbs_up)
               .backed_by_column_of_type(:integer)
    }
  end

  describe "object validity and persistence" do
    # Basic validity check
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "can be saved to the database" do
      subject.save!
      expect(subject).to be_persisted
    end
  end

  describe "emoji uniqueness" do
    # Uniqueness validation
    # Create a valid instance to test against
    before { create(:aurelius_press_community_like, :with_heart, user: user, likeable: document) }

    it "is not valid with a duplicate emoji reaction from the same user on the same item" do
      user = create(:aurelius_press_user)
      likeable = create(:aurelius_press_document_blog_post)
      create(:aurelius_press_community_like, user: user, likeable: likeable, emoji: :thumbs_up)
      duplicate_emoji_like = build(:aurelius_press_community_like, user: user, likeable: likeable, emoji: :thumbs_up)
      expect(duplicate_emoji_like).not_to be_valid
      # Expect the error message from our specific uniqueness validation
      expect(duplicate_emoji_like.errors.full_messages).to include("User You have already reacted to this item.")
    end

    it "is NOT valid with a different emoji reaction from the same user on the same item" do
      user = create(:aurelius_press_user)
      likeable = create(:aurelius_press_document_blog_post)
      create(:aurelius_press_community_like, user: user, likeable: likeable, emoji: :thumbs_up)
      different_emoji_like = build(:aurelius_press_community_like, user: user, likeable: likeable, emoji: :heart)
      expect(different_emoji_like).not_to be_valid
      # Expect the error message from our specific uniqueness validation
      expect(different_emoji_like.errors.full_messages).to include("User You have already reacted to this item.")
    end

    it "is valid with the same emoji reaction from a different user on the same item" do
      another_user = create(:aurelius_press_user)
      different_user_like = build(:aurelius_press_community_like, :with_heart, user: another_user, likeable: document)
      expect(different_user_like).to be_valid
    end

    it "is valid with the same emoji reaction from the same user on a different item" do
      another_document = create(:aurelius_press_document_page)
      different_item_like = build(:aurelius_press_community_like, :with_heart, user: user, likeable: another_document)
      expect(different_item_like).to be_valid
    end
  end
end
