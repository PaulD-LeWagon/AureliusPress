require "rails_helper"

RSpec.feature "Admin can manage a Comment (CRUD)", :js do
  # Users with different roles
  let!(:user) { create(:aurelius_press_user) }
  # Users with elevated permissions
  let!(:moderator) { create(:aurelius_press_moderator_user) }
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:superuser) { create(:aurelius_press_superuser_user) }
  # Add to array for easy iteration in tests
  let!(:power_users) { [moderator, admin, superuser] }
  # Create a blog post to associate comments with
  let!(:blog_post) { create(:aurelius_press_document_blog_post) }
  # Create a comments to work with
  let!(:comment_one) { create(:aurelius_press_fragment_comment, commentable: blog_post, user: user, content: "This is the first comment.") }

  scenario "READ - Power Users can view a list of all comments" do
    power_users.each do |the_actor|
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin comments index page
      visit aurelius_press_admin_fragment_comments_path
      # 3. Verify that the power user can see the comments
      expect(page).to have_content("View Comments")
      expect(page).to have_css("[template=\"AureliusPress::Admin::Fragment::Comments#index\"]")
      # 4. Assert that both comments created by FactoryBot are visible
      expect(page).to have_content(comment_one.content.body.to_plain_text.truncate(30))
      # 5. Sign out the user
      sign_out the_actor
    end
  end

  scenario "READ - Power Users can view a comment for moderation" do
    power_users.each do |the_actor|
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin comments index page
      visit aurelius_press_admin_fragment_comments_path
      # 3. Click on the comment to view its details
      click_link "View Details", href: aurelius_press_admin_fragment_comment_path(comment_one)
      # 4. Verify that we are in the correct view and the comment details are visible
      expect(page).to have_css("[template=\"AureliusPress::Admin::Fragment::Comments#show\"]")
      expect(page).to have_content("Viewing Comment")
      expect(page.text.squish).to include(comment_one.content.body.to_plain_text.squish)
      # 5. Sign out the user
      sign_out the_actor
    end
  end

  # @TODO: UPDATE test is not needed until we switch from hard-delete to soft-delete

  scenario "DELETE - Power Users can delete a comment" do
    power_users.each do |the_actor|
      # We're in a loop, REMEMBER!
      # So we need to ensure the state is reset for each iteration.
      # Hence, we recreate the comments if they were deleted in a prior iteration.
      # Clear out existing comments to ensure a clean state
      AureliusPress::Fragment::Comment.destroy_all
      # Ensure we have two comments to start with
      comment_one = create(:aurelius_press_fragment_comment, commentable: blog_post, user: user, content: "This is the first comment.") if comment_one.nil?
      comment_two = create(:aurelius_press_fragment_comment, commentable: blog_post, user: user, content: "This is the second comment.") if comment_two.nil?

      comment_text = comment_one.content.body.to_plain_text
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin comments index page
      visit aurelius_press_admin_fragment_comments_path
      # 3. Verify that the admin sees a list of comments (both created by FactoryBot)
      expect(AureliusPress::Fragment::Comment.count).to eq(2)
      # 4. Click on the comment to view its details
      click_link "View Details", href: aurelius_press_admin_fragment_comment_path(comment_one)
      # 5. Verify that the comment details are visible
      expect(page).to have_content("Viewing Comment")
      expect(page.text.squish).to include(comment_text.squish)
      # 6. Click the delete link for the first comment and confirm
      accept_confirm do
        click_link "Delete", href: aurelius_press_admin_fragment_comment_path(comment_one)
      end
      # 7. Verify the comment was deleted successfully
      expect(page).to have_content "Comment deleted successfully."
      expect(page).to have_current_path(aurelius_press_admin_fragment_comments_path)
      expect(page.text.squish).not_to include(comment_text.squish)
      expect(AureliusPress::Fragment::Comment.count).to eq(1)
      # 8. Sign out the user
      sign_out the_actor
    end
  end
end
