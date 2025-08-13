require "rails_helper"

RSpec.feature "User can manage a Page (CRUD)", :js do
  let!(:user) { create(:aurelius_press_user) }
  let!(:page_one) {
    create(
      :aurelius_press_document_page,
      :visible_to_www,
      title: "First Page",
      description: "Content of the first page.",
      user: user,
    )
  }
  let!(:page_two) {
    create(
      :aurelius_press_document_page,
      :visible_to_www,
      title: "Second Page",
      description: "Content of the second page.",
      user: create(:aurelius_press_user),
    )
  }

  scenario "CREATE - user can create a new page" do
    # 1. Log in as an user
    sign_in user
    # 2. Visit the new page form
    visit new_aurelius_press_page_path
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
    # Custom debug information
    print_debug_info
    # 5. Verify the success message and that the new page is visible
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(page).to have_content("Page was successfully created.")
  end

  scenario "READ - user can view a list of all pages" do
    # 1. Log in as an user using Devise helper
    sign_in user
    # 2. Navigate to the user pages index page
    visit aurelius_press_pages_path
    # Custom debug information
    print_debug_info
    # 3. Verify that the user can see the page titles and content
    expect(page).to have_content("All Pages")
    expect(page).to have_link("New Page", href: new_aurelius_press_page_path)
    # 4. Assert that both pages created by FactoryBot are visible
    expect(page).to have_content(page_one.title)
    expect(page).to have_content(page_one.description)
    expect(page).to have_content(page_two.title)
    expect(page).to have_content(page_two.description)
  end

  scenario "UPDATE - user can edit an existing page" do
    # Create a page to be edited
    page_to_edit = page_one
    # Log in as an user
    sign_in user
    # Navigate to the edit page
    visit edit_aurelius_press_page_path(page_to_edit)
    # Define the new attributes
    new_title = "Updated Title"
    new_description = "Updated description."
    # Fill out the form with the new data
    fill_in "Title", with: new_title
    fill_in "Description", with: new_description
    # Submit the form
    click_button "Update Page"
    # Custom debug information
    print_debug_info
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_content(new_title)
    expect(page).to have_content(new_description)
    expect(page).to have_content("Page was successfully updated.")
  end

  scenario "DELETE - user can delete a Page" do
    # 1. Log in as an user user
    sign_in user
    # 2. Navigate to the user pages index page
    visit aurelius_press_pages_path
    # 3. Verify that the user sees a list of pages
    expect(page).to have_content page_one.title
    expect(page).to have_content page_one.description
    expect(page).to have_content page_two.title
    expect(page).to have_content page_two.description
    expect(AureliusPress::Document::Page.count).to eq(2)
    # 4. Click the delete link for the first page and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_page_path(page_one)
    end
    # Custom debug information
    print_debug_info
    # 5. Verify the page was deleted successfully
    expect(page).to have_current_path(aurelius_press_pages_path)
    expect(page).not_to have_content page_one.title
    expect(AureliusPress::Document::Page.count).to eq(1)
    expect(page).to have_content "Page was successfully deleted."
  end

  scenario "BULK Operations - An user can perform bulk actions on Pages" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an user user
    # # 2. Navigate to the pages index page
    # # 3. Select multiple pages for bulk actions
    # # 4. Choose a bulk action from the dropdown
    # # 5. Confirm the bulk action
    # # 6. Verify the pages were deleted successfully
    # Custom debug information
    print_debug_info
  end
end
