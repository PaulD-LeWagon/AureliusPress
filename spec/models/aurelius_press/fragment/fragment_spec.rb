# == Schema Information
#
# Table name: aurelius_press_fragments
#
#  id               :bigint           not null, primary key
#  type             :string           not null
#  user_id          :bigint           not null
#  commentable_type :string
#  commentable_id   :bigint
#  title            :string
#  position         :integer          default(0), not null
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  notable_type     :string
#  notable_id       :bigint
#
require "rails_helper"
# Attributes:
# [Required] type: string, used for Single Table Inheritance (STI)
# [Required] user: references, the user who created the fragment
# [Required] commentable: references{polymorphic}, allows fragments to be associated with different document types
# [Required] status: enum, representing the fragment's status (draft, published, archived)
# [Required] visibility: enum, representing who can see the fragment (private_to_owner, etc.)
# [Required] content: text, rich text content for fragments that support it
# Callbacks: Ensure content is always present for ActionText fields

RSpec.describe AureliusPress::Fragment::Fragment, type: :model do
  let!(:commenter) { create(:aurelius_press_user) }
  let!(:fragment) { build(:aurelius_press_fragment_fragment, user: commenter) }

  it { should define_enum_for(:status).with_values([:draft, :published, :archived]) }
  it { should define_enum_for(:visibility).with_values([:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]) }

  it { should have_rich_text(:content) }
  it { should validate_presence_of(:content) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:visibility) }

  it "is a Fragment" do
    expect(fragment).to be_a(AureliusPress::Fragment::Fragment)
  end

  it "does not inherit from Document" do
    expect(described_class.superclass).to_not eq(AureliusPress::Document::Document)
  end

  it "STI Superclass has type set to [nil]" do
    expect(fragment.type).to be_nil
  end

  it "has valid attributes (except TYPE)" do
    expect(fragment.user).to be_present
    expect(fragment.user).to be_a(AureliusPress::User)
    expect(fragment.status).to eq("draft")
    expect(fragment.visibility).to eq("private_to_owner")
    expect(fragment.content).to be_present
  end

  it "has a valid author/commenter (User)" do
    expect(fragment.user).to be_present
    expect(fragment.user).to be_valid
    expect(fragment.user).to be_persisted
    expect(fragment.user).to be_a(AureliusPress::User)
  end

  it "has rich text content" do
    expect(fragment.content.body.to_plain_text).to be_present
  end
end
