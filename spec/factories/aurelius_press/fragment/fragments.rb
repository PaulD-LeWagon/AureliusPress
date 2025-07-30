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
