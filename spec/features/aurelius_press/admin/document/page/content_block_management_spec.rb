require "rails_helper"

def wait_for_link_with(text)
  Capybara.current_session.find("a", text: text)
end

RSpec.feature "Admin can manage ContentBlocks", :js, type: :feature do
  # Create a test admin user
  before do
    @admin = create(:aurelius_press_admin_user)
    sign_in @admin
  end

  after do
    sign_out @admin
    @admin.destroy if @admin
    @admin = nil
  end

  scenario "CREATE - Admin can create and add a content block to a page" do
    # 1. Visit the new page form
    visit new_aurelius_press_admin_document_page_path
    # 2. create the content
    rtc = "This is the rich text content."
    the_title = "A New Page with a Content Block"
    the_description = "This is the description for the new page."
    # 3. Fill out the form with valid data
    fill_in "* Title", with: the_title
    fill_in "Description", with: the_description
    select "published", from: "Status"
    select "public_to_www", from: "Visibility"
    # 4. Add a content block. However, the #click_link method is not working with vanilla_js links
    wait_for_link_with("Add Rich Text Block").click
    # expect the Trix editor to be present
    expect(page).to have_css(".trix-content")
    # 5. fill in the rich text content
    fill_in_rich_text_area "trix-content", with: rtc
    # 6. Submit the form
    click_button "Create Page"
    # 7. Verify the success message and that the new page is visible
    expect(page).to have_content(the_description)
    expect(page).to have_content(the_title)
    expect(page).to have_content(rtc)
    expect(page).to have_content("Page was successfully created.")
  end

  fscenario "READ - Admin can view a page with content blocks" do
    page = create(
      :aurelius_press_document_page,
      :with_one_of_each_content_block,
      title: "Test Page with One of Each Content Block Type",
    )
    # 1. Visit the show page
    visit aurelius_press_admin_document_page_path(page)
    # 2. Verify the content blocks are displayed
    expect(page).to have_content("Test Page with One of Each Content Block Type")
    expect(page).to have_css("trix-content")
  end

  scenario "UPDATE - Admin can update an existing content block" do
    # 1. Create a page with one of each content block type
    @page = create(:aurelius_press_document_page, :with_one_of_each_content_block)
    # 2. Visit the edit page for the existing content block
    visit edit_aurelius_press_admin_document_page_path(@page)
    # 3. Update the content block details
    fill_in "Title", with: "Updated Title"
    fill_in "Description", with: "Updated Description"
    select "draft", from: "Status"
    select "private", from: "Visibility"
    # 4. Edit a content block
    #    This will fail as there is no such link and will never be implemented.
    click_link "Edit Content Block"
    # 5. Submit the form
    click_button "Update Page"
    # 6. Verify the success message and that the updated page is visible
    expect(page).to have_content("Page was successfully updated.")
    expect(page).to have_content("Updated Title")
    expect(page).to have_content("Updated Description")
  end

  scenario "DELETE - Admin can delete an existing content block" do
    skip "Not yet implemented."
    # 1. Create a page with one of each content block type
    @page = create(:aurelius_press_document_page, :with_one_of_each_content_block)
    # 2. Visit the edit page for the existing content block
    visit edit_aurelius_press_admin_document_page_path(@page)
    # 3. Delete a content block
    #    This will fail as there is no such link and will never be implemented.
    click_link "Delete Content Block"
    # 4. Submit the form
    click_button "Update Page"
    # 5. Verify the success message and that the updated page is visible
    expect(page).to have_content("Page was successfully updated.")
    expect(page).not_to have_content("Content Block Title")
  end
end
