# spec/models/blog_post_spec.rb
require "rails_helper"

RSpec.describe BlogPost, type: :model do
  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    blog_post = create(:blog_post)
    expect(blog_post.type).to eq("BlogPost")
  end

  # Test any specific BlogPost associations or validations here if added
end
