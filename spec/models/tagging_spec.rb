# spec/models/tagging_spec.rb
require "rails_helper"

RSpec.describe Tagging, type: :model do
  describe "associations" do
    it { should belong_to(:document) }
    it { should belong_to(:tag) }
  end

  # You might add uniqueness validation for a document-tag pair if desired:
  # it { should validate_uniqueness_of(:tag_id).scoped_to(:document_id) }
end
