FactoryBot.define do
  factory :aurelius_press_fragment_note, parent: :aurelius_press_fragment_fragment, class: "AureliusPress::Fragment::Note" do
    association :notable, factory: :aurelius_press_document_blog_post
    type { "AureliusPress::Fragment::Note" }
    title { Faker::Book.title }
    status { :draft }
    visibility { :private_to_owner }
    sequence(:position) { |n| n }
    after(:build) do |note|
      note.content = ActionText::RichText.new(content: Faker::Lorem.paragraphs(number: 1)) if note.content.blank?
    end
  end
end
