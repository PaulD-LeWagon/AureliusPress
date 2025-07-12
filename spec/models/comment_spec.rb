# spec/models/comment_spec.rb
require "rails_helper"

RSpec.describe Comment, type: :model do
  # Test Associations
  describe "associations" do
    # Comment belongs to a User
    it { should belong_to(:user) }
    # Comment has a polymorphic association to commentable
    it { should belong_to(:commentable) }
  end

  # Test Enums
  describe "enums" do
    it { should define_enum_for(:visibility).with_values([:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]) }
  end

  # Test creation with polymorphic association
  describe "polymorphic commentable" do
    it "can be associated with a Document" do
      document = create(:document)
      comment = create(:comment, commentable: document)
      expect(comment.commentable).to eq(document)
    end

    it "can be associated with a BlogPost" do
      blog_post = create(:blog_post)
      comment = create(:comment, commentable: blog_post)
      expect(comment.commentable).to eq(blog_post)
    end

    it "can be associated with another Comment" do
      parent_comment = create(:comment)
      child_comment = create(:comment, commentable: parent_comment)
      expect(child_comment.commentable).to eq(parent_comment)
    end
  end
end
