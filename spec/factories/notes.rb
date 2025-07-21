# spec/factories/notes.rb
FactoryBot.define do
  factory :note, parent: :fragment, class: Note do
    association :notable, factory: :blog_post
    type { "Note" }
    title { Faker::Book.title }
    status { :draft }
    visibility { :private_to_owner }
    sequence(:position) { |n| n }
  end
end
