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
# spec/models/reaction_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Community::Reaction, type: :model do
  # Factories
  let(:user) { create(:aurelius_press_user) }
  let(:document) { create(:aurelius_press_document_blog_post) }
  # Subject for basic valid state
  # Default emoji is thumbs_up but set it explicitly for clarity
  subject { create(:aurelius_press_community_reaction, user: user, reactable: document, emoji: :no_reaction) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:reactable) }
  end

  describe "class validations" do
    # Presence validations
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:reactable_id) }
    it { should validate_presence_of(:reactable_type) }
    it { should validate_presence_of(:emoji) }

    # Enum validation
    it {
      should define_enum_for(:emoji)
               .with_values({
                 no_reaction: 0,
                 thumbs_up: 1,
                 heart: 2,
                 rolling_on_the_floor_laughing: 3,
                 clapping_hands: 4,
                 thinking_face: 5,
                 shocked_face: 6,
                 sad_face: 7,
                 angry_face: 8,
                 fire: 9,
                 eyes: 10,
                 party_popper: 11,
                 raised_hands: 12,
                 star_struck: 13
               })
               .with_default(:no_reaction)
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
    before { create(:aurelius_press_community_reaction, :with_heart, user: user, reactable: document) }

    it "is not valid with a duplicate emoji reaction from the same user on the same item" do
      user = create(:aurelius_press_user)
      reactable = create(:aurelius_press_document_blog_post)
      create(:aurelius_press_community_reaction, user: user, reactable: reactable, emoji: :thumbs_up)
      duplicate_emoji_reaction = build(:aurelius_press_community_reaction, user: user, reactable: reactable, emoji: :thumbs_up)
      expect(duplicate_emoji_reaction).not_to be_valid
      # Expect the error message from our specific uniqueness validation
      expect(duplicate_emoji_reaction.errors.full_messages).to include("User You have already reacted to this item.")
    end

    it "is NOT valid with a different emoji reaction from the same user on the same item" do
      user = create(:aurelius_press_user)
      reactable = create(:aurelius_press_document_blog_post)
      create(:aurelius_press_community_reaction, user: user, reactable: reactable, emoji: :thumbs_up)
      different_emoji_reaction = build(:aurelius_press_community_reaction, user: user, reactable: reactable, emoji: :heart)
      expect(different_emoji_reaction).not_to be_valid
      # Expect the error message from our specific uniqueness validation
      expect(different_emoji_reaction.errors.full_messages).to include("User You have already reacted to this item.")
    end

    it "is valid with the same emoji reaction from a different user on the same item" do
      another_user = create(:aurelius_press_user)
      different_user_reaction = build(:aurelius_press_community_reaction, :with_heart, user: another_user, reactable: document)
      expect(different_user_reaction).to be_valid
    end

    it "is valid with the same emoji reaction from the same user on a different item" do
      another_document = create(:aurelius_press_document_page)
      different_item_reaction = build(:aurelius_press_community_reaction, :with_heart, user: user, reactable: another_document)
      expect(different_item_reaction).to be_valid
    end
  end
end
