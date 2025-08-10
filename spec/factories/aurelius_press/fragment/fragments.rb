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
FactoryBot.define do
  factory :aurelius_press_fragment_fragment, class: "AureliusPress::Fragment::Fragment" do
    # Attributes:
    # [Required] type: string, used for Single Table Inheritance (STI)
    # [Required] user: references, the user who created the fragment
    # [Required] commentable: references{polymorphic}, allows fragments to be associated with different document types
    # [Required] status: enum, representing the fragment's status (draft, published, archived)
    # [Required] visibility: enum, representing who can see the fragment (private_to_owner, etc.)
    # [Required] content: text, rich text content for fragments that support it

    type { nil }
    association :user, factory: :aurelius_press_user
    status { :draft }
    visibility { :private_to_owner }

    # Callbacks: Ensure content is always present for ActionText fields
    after(:build) do |fragment|
      fragment.content = ActionText::RichText.new(body: Faker::Lorem.paragraphs(number: 3).join("\n\n"))
    end
  end
end
