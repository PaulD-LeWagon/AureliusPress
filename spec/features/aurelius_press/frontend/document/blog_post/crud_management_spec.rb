require "rails_helper"

RSpec.feature "user can manage a Blog Post (CRUD)", :js do
  let!(:user) { create(:aurelius_press_user) }
  let!(:post_one) {
    create(:aurelius_press_document_blog_post,
           :visible_to_www,
           title: "First Post",
           description: "Content of the first post.",
           user: user)
  }
  let!(:post_two) {
    create(:aurelius_press_document_blog_post,
           :visible_to_www,
           title: "Second Post",
           description: "Content of the second post.")
  }

  scenario "CREATE - User can create a new post" do
    # 1. Log in as an user
    sign_in user
    # 2. Visit the new page form
    visit new_aurelius_press_blog_post_path
    # 3. Fill out the form with valid data
    title = "A New Blog Post Title"
    description = "This is the content for the new blog post."
    fill_in "Title", with: title
    fill_in "Description", with: description
    select "Published", from: "Status"
    select "Public To Www", from: "Visibility"
    # 4. Submit the form
    click_button "Create"
    # save_and_open_page
    # 5. Verify the success message and that the new blog post is visible
    expect(page).to have_content("Blog post created successfully.")
    expect(page).to have_content(title)
    expect(page).to have_content(description)
  end

  scenario "READ - user can view a list of all blog posts" do
    # 1. Log in as an user using Devise helper
    sign_in user
    # 2. Navigate to the user blog posts index page
    visit aurelius_press_blog_posts_path
    # 3. Verify that the user can see the blog post titles and content
    expect(page).to have_content("All Posts")
    expect(page).to have_link("Add New Post", href: new_aurelius_press_blog_post_path)
    # 4. Assert that both blog posts created by FactoryBot are visible
    expect(page).to have_content(post_one.title)
    expect(page).to have_content(post_one.description)
    expect(page).to have_content(post_two.title)
    expect(page).to have_content(post_two.description)
  end

  scenario "UPDATE - user can edit an existing blog post" do
    # Create a blog post to be edited
    blog_post_to_edit = post_one
    # Log in as an user
    sign_in user
    # Navigate to the edit page
    visit edit_aurelius_press_blog_post_path(blog_post_to_edit)
    # Define the new attributes
    new_title = "Updated Blog Post Title"
    new_description = "Updated blog post description."
    # Fill out the form with the new data
    fill_in "Title", with: new_title
    fill_in "Description", with: new_description
    # Submit the form
    click_button "Update"
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_current_path(aurelius_press_blog_post_path(blog_post_to_edit.reload))
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_description)
    expect(page).to have_content("Blog post updated successfully.")
  end

  scenario "DELETE - user can delete a Blog post" do
    # 1. Log in as an user user
    sign_in user
    # 2. Navigate to the user blog posts index page
    visit aurelius_press_blog_posts_path
    # 3. Verify that the user sees a list of blog posts
    expect(page).to have_content post_one.title
    expect(page).to have_content post_one.description
    expect(page).to have_content post_two.title
    expect(page).to have_content post_two.description
    expect(AureliusPress::Document::BlogPost.count).to eq(2)
    # 4. Click the delete link for the first blog post and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_blog_post_path(post_one)
    end
    # 5. Verify the blog post was deleted successfully
    expect(page).to have_current_path(aurelius_press_blog_posts_path)
    expect(page).not_to have_content post_one.title
    expect(AureliusPress::Document::BlogPost.count).to eq(1)
    expect(page).to have_content "Blog post deleted successfully."
  end

  scenario "BULK Operations - An user can perform bulk actions on Blog posts" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an user user
    # # 2. Navigate to the blog posts index page
    # # 3. Select multiple blog posts for bulk actions
    # # 4. Choose a bulk action from the dropdown
    # # 5. Confirm the bulk action
    # # 6. Verify the blog posts were deleted successfully
  end
end
