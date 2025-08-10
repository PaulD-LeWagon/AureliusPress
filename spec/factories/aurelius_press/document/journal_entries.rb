# == Schema Information
#
# Table name: aurelius_press_documents
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  category_id      :bigint
#  type             :string           not null
#  slug             :string           not null
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
# spec/factories/journal_entries.rb
FactoryBot.define do
  factory :aurelius_press_document_journal_entry, parent: :aurelius_press_document_document, class: "AureliusPress::Document::JournalEntry" do
    type { "AureliusPress::Document::JournalEntry" }
    comments_enabled { true }
    # Default visibility specific to JournalEntry
    visibility { :private_to_owner }
  end
end
