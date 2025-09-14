# spec/features/aurelius_press/admin/fragment/comment_crud_spec.rb

require "rails_helper"

RSpec.feature "Admin can manage a Comment (CRUD)", :js do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:blog_post) { create(:aurelius_press_document_blog_post) }
  let!(:comment_one) { create(:aurelius_press_fragment_comment, commentable: blog_post, user: admin, content: "This is the first comment.") }
  let!(:comment_two) { create(:aurelius_press_fragment_comment, commentable: blog_post, user: admin, content: "This is the second comment.") }

  scenario "CREATE - Admin can create a new comment" do
    # 1. Log in as an admin
    sign_in admin
    # 2. Visit the new comment form
    visit new_aurelius_press_admin_fragment_comment_path
    # 3. Fill out the form
    rich_text_content = "A new comment has been created."
    fill_in_rich_text_area "trix-content", with: rich_text_content
    select "Published", from: "Status"
    select "Public To Www", from: "Visibility"
    # Assuming your form has fields to select the commentable type/id
    # fill_in "Commentable", with: page.id
    # 4. Submit the form
    click_button "Create"
    # 5. Verify the success message and that the new comment is visible
    expect(page).to have_content("Comment created successfully.")
    expect(page).to have_content(rich_text_content)
  end

  scenario "READ - Admin can view a list of all comments" do
    # 1. Log in as an admin
    sign_in admin
    # 2. Navigate to the admin comments index page
    visit aurelius_press_admin_fragment_comments_path
    # 3. Verify that the admin can see the comments
    expect(page).to have_content("Comments")
    expect(page).to have_link("New Comment", href: new_aurelius_press_admin_fragment_comment_path)
    # 4. Assert that both comments created by FactoryBot are visible
    expect(page).to have_content(comment_one.content.body.to_plain_text)
    expect(page).to have_content(comment_two.content.body.to_plain_text)
  end

  scenario "UPDATE - Admin can edit an existing comment" do
    # Log in as an admin
    sign_in admin
    # Navigate to the edit comment page
    visit edit_aurelius_press_admin_fragment_comment_path(comment_one)
    # Define the new content
    updated_content = "This is the updated content for the comment."
    # Fill out the form with the new data
    fill_in_rich_text_area "trix-content", with: updated_content
    select "Archived", from: "Status"
    # Submit the form
    click_button "Update"
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_content("Comment updated successfully.")
    expect(page).to have_content(updated_content)
  end

  scenario "DELETE - Admin can delete a comment" do
    comment_text = comment_one.content.body.to_plain_text.truncate(30)
    # 1. Log in as an admin user
    sign_in admin
    # 2. Navigate to the admin comments index page
    visit aurelius_press_admin_fragment_comments_path
    # 3. Verify that the admin sees a list of comments
    expect(page).to have_content comment_text
    expect(AureliusPress::Fragment::Comment.count).to eq(2)
    # 4. Click the delete link for the first comment and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_admin_fragment_comment_path(comment_one)
    end
    # 5. Verify the comment was deleted successfully
    expect(page).to have_content "Comment deleted successfully."
    expect(page).to have_current_path(aurelius_press_admin_fragment_comments_path)
    expect(page).not_to have_content comment_text
    expect(AureliusPress::Fragment::Comment.count).to eq(1)
  end
end
