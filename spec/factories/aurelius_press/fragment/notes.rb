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
