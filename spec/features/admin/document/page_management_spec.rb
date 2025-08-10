require "rails_helper"

RSpec.feature "Admin can manage a Page (CRUD)", :js do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:page_one) { create(:aurelius_press_document_page, title: "First Page", description: "Content of the first page.") }
  let!(:page_two) { create(:aurelius_press_document_page, title: "Second Page", description: "Content of the second page.") }

  scenario "CREATE - Admin can create a new page" do
    # 1. Log in as an admin
    sign_in admin
    # 2. Visit the new page form
    visit new_aurelius_press_admin_document_page_path
    # 3. Fill out the form with valid data
    title = "A New Page Title"
    description = "This is the content for the new page."
    fill_in "Title", with: title
    fill_in "Description", with: description
    select "published", from: "Status"
    select "public_to_www", from: "Visibility"
    fill_in "Tags (comma separated)", with: "new, page, tags"
    # 4. Submit the form
    click_button "Create Page"
    # save_and_open_page
    # 5. Verify the success message and that the new page is visible
    expect(page).to have_content("Page was successfully created.")
    expect(page).to have_content(title)
    expect(page).to have_content(description)
  end

  scenario "READ - Admin can view a list of all pages" do
    # 1. Log in as an admin using Devise helper
    sign_in admin
    # 2. Navigate to the admin pages index page
    visit aurelius_press_admin_document_pages_path
    # 3. Verify that the admin can see the page titles and content
    expect(page).to have_content("Pages")
    expect(page).to have_link("New Page", href: new_aurelius_press_admin_document_page_path)
    # 4. Assert that both pages created by FactoryBot are visible
    expect(page).to have_content(page_one.title)
    expect(page).to have_content(page_one.description)
    expect(page).to have_content(page_two.title)
    expect(page).to have_content(page_two.description)
  end

  scenario "UPDATE - Admin can edit an existing page" do
    # Create a page to be edited
    # page_to_edit = create(:aurelius_press_page, user: admin, title: "Original Title", description: "Original description.")
    page_to_edit = page_one
    # Log in as an admin
    sign_in admin
    # Navigate to the edit page
    visit edit_aurelius_press_admin_document_page_path(page_to_edit)
    # Define the new attributes
    new_title = "Updated Title"
    new_description = "Updated description."
    # Fill out the form with the new data
    fill_in "Title", with: new_title
    fill_in "Description", with: new_description
    # Submit the form
    click_button "Update Page"
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_content("Page was successfully updated.")
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_description)
  end

  scenario "DELETE - Admin can delete a Page" do
    # 1. Log in as an admin user
    sign_in admin
    # 2. Navigate to the admin pages index page
    visit aurelius_press_admin_document_pages_path
    # 3. Verify that the admin sees a list of pages
    expect(page).to have_content page_one.title
    expect(page).to have_content page_one.description
    expect(page).to have_content page_two.title
    expect(page).to have_content page_two.description
    expect(AureliusPress::Document::Page.count).to eq(2)
    # 4. Click the delete link for the first page and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_admin_document_page_path(page_one)
    end
    # 5. Verify the page was deleted successfully
    expect(page).to have_content "Page was successfully destroyed."
    expect(page).to have_current_path(aurelius_press_admin_document_pages_path)
    expect(page).not_to have_content page_one.title
    expect(AureliusPress::Document::Page.count).to eq(1)
  end

  scenario "BULK Operations - An admin can perform bulk actions on Pages" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an admin user
    # # 2. Navigate to the pages index page
    # # 3. Select multiple pages for bulk actions
    # # 4. Choose a bulk action from the dropdown
    # # 5. Confirm the bulk action
    # # 6. Verify the pages were deleted successfully
  end
end
