require "rails_helper"

RSpec.feature "Admin can manage an AtomicBlogPost (CRUD)", :js do
  let!(:categories) { create_list(:aurelius_press_taxonomy_category, 3) }
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:atomic_blog_post_one) { create(:aurelius_press_document_atomic_blog_post, title: "First Atomic Blog Post", description: "Content of the first atomic blog post.") }
  let!(:atomic_blog_post_two) { create(:aurelius_press_document_atomic_blog_post, title: "Second Atomic Blog Post", description: "Content of the second atomic blog post.") }

  scenario "CREATE - Admin can create a new Atomic Blog Post" do
    # 1. Log in as an admin
    sign_in admin
    # 2. Visit the new atomic blog post form
    visit new_aurelius_press_admin_document_atomic_blog_post_path
    # 3. Fill out the form with valid data
    title = "A New Atomic Blog Post Title"
    description = "This is the content for the new atomic blog post."
    content = "<p>This is the main content of the new page.</p>"
    fill_in "Title", with: title
    fill_in "Description", with: description
    select "published", from: "Status"
    select "public_to_www", from: "Visibility"
    select categories.first.name, from: "Category"
    fill_in "Tags (comma separated)", with: "new, atomic, blog, post"
    fill_in_rich_text_area "trix-content", with: content
    attach_file "Featured Image", Rails.root.join("spec/fixtures/files/test_image.png")
    # save_and_open_page
    # 4. Submit the form
    click_button "Create Atomic blog post"
    # save_and_open_page
    # 5. Verify the success message and that the new atomic blog post is visible
    expect(page).to have_content("Atomic blog post was successfully created.")
    expect(page).to have_content(title)
    expect(page).to have_content(description)
  end

  scenario "READ - Admin can view a list of all Atomic Blog Posts" do
    # 1. Log in as an admin using Devise helper
    sign_in admin
    # 2. Navigate to the admin atomic blog posts index page
    visit aurelius_press_admin_document_atomic_blog_posts_path
    # 3. Verify that the admin can see the atomic blog post titles and content
    expect(page).to have_content("Atomic Blog Posts")
    expect(page).to have_link("New Atomic Blog Post", href: new_aurelius_press_admin_document_atomic_blog_post_path)
    # 4. Assert that both atomic blog posts created by FactoryBot are visible
    expect(page).to have_content(atomic_blog_post_one.title)
    expect(page).to have_content(atomic_blog_post_one.description)
    expect(page).to have_content(atomic_blog_post_two.title)
    expect(page).to have_content(atomic_blog_post_two.description)
  end

  scenario "UPDATE - Admin can edit an existing Atomic Blog Post" do
    # Create a Atomic Blog Post to be edited
    atomic_blog_post_to_edit = atomic_blog_post_one
    # Log in as an admin
    sign_in admin
    # Navigate to the edit page
    visit edit_aurelius_press_admin_document_atomic_blog_post_path(atomic_blog_post_to_edit)
    # Define the new attributes
    new_title = "Updated Atomic Blog Post Title"
    new_description = "Updated atomic blog post description."
    # Fill out the form with the new data
    fill_in "Title", with: new_title
    fill_in "Description", with: new_description
    # Submit the form
    click_button "Update Atomic blog post"
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_content("Atomic blog post was successfully updated.")
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_description)
  end

  scenario "DELETE - Admin can delete a Atomic Blog Post" do
    # 1. Log in as an admin user
    sign_in admin
    # 2. Navigate to the admin atomic blog posts index page
    visit aurelius_press_admin_document_atomic_blog_posts_path
    # 3. Verify that the admin sees a list of atomic blog posts
    expect(page).to have_content atomic_blog_post_one.title
    expect(page).to have_content atomic_blog_post_one.description
    expect(page).to have_content atomic_blog_post_two.title
    expect(page).to have_content atomic_blog_post_two.description
    expect(AureliusPress::Document::AtomicBlogPost.count).to eq(2)
    # 4. Click the delete link for the first atomic blog post and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_admin_document_atomic_blog_post_path(atomic_blog_post_one)
    end
    # 5. Verify the atomic blog post was deleted successfully
    expect(page).to have_content "Atomic blog post was successfully destroyed."
    expect(page).to have_current_path(aurelius_press_admin_document_atomic_blog_posts_path)
    expect(page).not_to have_content atomic_blog_post_one.title
    expect(AureliusPress::Document::AtomicBlogPost.count).to eq(1)
  end

  scenario "BULK Operations - An admin can perform bulk actions on Atomic Blog Posts" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an admin user
    # # 2. Navigate to the atomic blog posts index page
    # # 3. Select multiple atomic blog posts for bulk actions
    # # 4. Choose a bulk action from the dropdown
    # # 5. Confirm the bulk action
    # # 6. Verify the atomic blog posts were deleted successfully
  end
end
