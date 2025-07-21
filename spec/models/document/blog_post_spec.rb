require "rails_helper"

RSpec.describe BlogPost, type: :model do
  let!(:the_blog_post) { create(:blog_post, :with_belt_and_braces) }

  it "is a valid BlogPost" do
    expect(the_blog_post).to be_valid
    expect(the_blog_post).to be_a(BlogPost)
  end

  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    expect(the_blog_post.type).to eq("BlogPost")
  end

  it "has valid attributes" do
    expect(the_blog_post.title).to be_present
    expect(the_blog_post.slug).to be_present
    expect(the_blog_post.subtitle).to be_present
    expect(the_blog_post.description).to be_present
    expect(the_blog_post.status).to eq("published")
    expect(the_blog_post.visibility).to eq("public_to_www")
    expect(the_blog_post.published_at).to be_present
    expect(the_blog_post.published_at).to be < Time.current
    expect(the_blog_post.user).to be_present
    expect(the_blog_post.user).to be_a(User)
  end

  it "has a valid author (User)" do
    expect(the_blog_post.user).to be_present
    expect(the_blog_post.user).to be_valid
    expect(the_blog_post.user).to be_persisted
    expect(the_blog_post.user).to be_a(User)
  end

  it "has valid content blocks" do
    expect(the_blog_post.content_blocks).to be_present
    expect(the_blog_post.content_blocks.count).to eq(3)
    expect(the_blog_post.content_blocks.first).to be_a(ContentBlock)
  end

  it "has a valid category" do
    expect(the_blog_post.category).to be_present
    expect(the_blog_post.category).to be_a(Category)
  end

  it "has valid tags" do
    expect(the_blog_post.tags).to be_present
    expect(the_blog_post.tags.count).to eq(3)
    expect(the_blog_post.tags.first).to be_a(Tag)
  end

  it "has valid likes" do
    expect(the_blog_post.likes).to be_present
    expect(the_blog_post.likes.count).to eq(3)
    expect(the_blog_post.likes.first).to be_a(Like)
  end

  it "has valid comments" do
    expect(the_blog_post.comments_enabled).to be true
    expect(the_blog_post.comments.count).to eq(3)
    the_blog_post.comments.each do |comment|
      expect(comment).to be_present
      expect(comment).to be_valid
      expect(comment).to be_persisted
      expect(comment).to be_a(Comment)
      comment.replies.each do |reply|
        expect(reply).to be_present
        expect(reply).to be_valid
        expect(reply).to be_persisted
        expect(reply).to be_a(Comment)
        reply.replies.each do |reply_reply|
          expect(reply_reply).to be_present
          expect(reply_reply).to be_valid
          expect(reply_reply).to be_persisted
          expect(reply_reply).to be_a(Comment)
        end
      end
    end
  end
end
