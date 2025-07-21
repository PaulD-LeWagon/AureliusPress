# spec/models/comment_spec.rb
require "rails_helper"

RSpec.describe Comment, type: :model do
  # Test Validations
  describe "validations" do
    it "validates type [Comment] on a BlogPost" do
      comment = create(:comment, :on_blog_post, title: "Test Comment on a Blog Post")
      expect(comment).to be_valid
      expect(comment.type).to eq("Comment")
      should validate_presence_of(:type)
    end
    it { should validate_presence_of(:content) }
  end

  # Test Associations
  describe "associations" do
    # Comment belongs to a User
    it { should belong_to(:user) }
    # Comment has a polymorphic association to commentable
    it { should belong_to(:commentable) }
    # Comment can have many replies (child comments)
    it { should have_many(:replies).class_name("Comment").dependent(:destroy) }
    # Comment can have many likes
    it { should have_many(:likes).dependent(:destroy) }
  end

  # Test Enums
  describe "enums" do
    visibilities = [
      :private_to_owner,
      :private_to_group,
      :private_to_app_users,
      :public_to_www,
    ]
    it { should define_enum_for(:visibility).with_values(visibilities) }
    statuses = [
      :draft,
      :published,
      :archived,
    ]
    it { should define_enum_for(:status).with_values(statuses) }
  end

  describe "polymorphic associations" do
    it "is polymorphic and can be associated with different models" do
      expect(Comment.reflect_on_association(:commentable).options[:polymorphic]).to be true
    end

    it "creates a comment on an AtomicBlogPost" do
      comment = create(:comment, :on_atomic_blog_post, title: "Comment on an Atomic Blog Post")
      expect(comment).to be_persisted
      expect(comment.commentable).to be_a(AtomicBlogPost)
    end

    it "creates a comment on a BlogPost" do
      comment = create(:comment, :on_blog_post, title: "Comment on a Blog Post")
      expect(comment).to be_persisted
      expect(comment.commentable).to be_a(BlogPost)
    end

    it "creates a BlogPost with 3 comments on it" do
      blog_post = create(:blog_post, :with_3_comments, title: "3 Comments on a Blog Post")
      expect(blog_post.comments.count).to eq(3)
      blog_post.comments.each do |comment|
        expect(comment).to be_a(Comment)
        expect(comment.commentable).to eq(blog_post)
      end
    end

    it "creates a comment on a JournalEntry" do
      comment = create(:comment, :on_journal_entry, title: "Comment on a Journal Entry")
      expect(comment).to be_persisted
      expect(comment.commentable).to be_a(JournalEntry)
    end

    it "can [NOT] create a comment on a Page" do
      comment = build(:comment, :on_page, title: "Can we add a comment to a Page!?")
      expect(comment).not_to be_valid
      expect(comment.commentable[:commentable_type]).to be_nil
      expect(comment.errors[:commentable_type]).to be_present
      expect(comment.errors[:commentable_type]).to include("[Page] is not a commentable document type.")
    end
  end

  describe "Nested comments/replies" do
    it "creates a comment with a reply (comment)" do
      comment = create(:comment) # First, create a comment to reply to
      reply = create(:comment, :on_another_comment, commentable: comment, title: "A reply")
      expect(reply).to be_persisted
      expect(reply.commentable).to eq(comment)
    end

    it "comment > child_comment > grand_child_comment" do
      blog_post = create(
        :blog_post,
        :with_parent_child_grandchild_comments,
        title: "Blog Post with Nested Comments",
        comments_enabled: true,
      )
      expect(blog_post.comments.count).to eq(1) # 1 top-level comment
      blog_post.comments.each do |comment|
        expect(comment).to be_a(Comment)
        expect(comment.commentable).to eq(blog_post)
        expect(comment.replies.count).to eq(1) # 1 child comment
        comment.replies.each do |reply|
          expect(reply).to be_a(Comment)
          expect(reply.replies.count).to eq(1) # 1 grandchild comment
          expect(reply.commentable).to eq(comment)
          reply.replies.each do |grand_child_reply|
            expect(grand_child_reply).to be_a(Comment)
            expect(grand_child_reply.replies.count).to eq(0) # 0 replies
            expect(grand_child_reply.commentable).to eq(reply)
          end
        end
      end
    end

    it "has a tree structure: blog post with comments on comments on comments [3^3]" do
      blog_post = create(
        :blog_post,
        :with_belt_and_braces,
        title: "Blog Post with 3x3x3 Comments Published and Visible to WWW",
      )
      expect(blog_post).to be_persisted
      expect(blog_post.comments_enabled).to be true
      expect(blog_post.comments.count).to eq(3) # 3 top-level comments
      blog_post.comments.each do |comment|
        expect(comment).to be_a(Comment)
        expect(comment.replies.count).to eq(3) # 3 child comments
        comment.replies.each do |reply|
          expect(reply).to be_a(Comment)
          expect(reply.replies.count).to eq(3) # 3 grandchild comments
          reply.replies.each do |grand_child_reply|
            expect(grand_child_reply).to be_a(Comment)
            expect(grand_child_reply.replies.count).to eq(0) # 0 replies
          end
        end
      end
    end
  end
end
