# spec/models/page_spec.rb
require "rails_helper"

RSpec.describe Page, type: :model do
  # Test STI specific behaviour
  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    page = create(:page)
    expect(page.type).to eq("Page")
    expect(page).to be_a(Document) # Still acts as a Document
  end

  # Inherits validations, associations etc. from Document,
  # so no need to re-test them unless there are specific overrides.
end
