require "rails_helper"

def wait_for_link_with(text)
  Capybara.current_session.find("a", text: text)
end

RSpec.feature "User can manage ContentBlocks", :js, type: :feature do
  # Create a test user
  before do
    @user = create(:aurelius_press_user)
    sign_in @user
  end

  after do
    sign_out @user
    @user.destroy if @user
    @user = nil
  end

  scenario "CREATE - User can create and add a content block to a page" do
    # 1. Visit the new page form
    visit new_aurelius_press_page_path
    # 2. create the content
    rtc = "This is the rich text content."
    the_title = "A New Page with a Content Block"
    the_description = "This is the description for the new page."
    # 3. Fill out the form with valid data
    fill_in "* Title", with: the_title
    fill_in "Description", with: the_description
    select "Published", from: "Status"
    select "Public To Www", from: "Visibility"
    # 4. Add a content block.
    click_button("+ Text")
    # expect the Trix editor to be present
    expect(page).to have_css(".trix-content")
    # 5. fill in the rich text content
    fill_in_rich_text_area "trix-content", with: rtc
    # 6. Submit the form
    click_button "Create"
    # 7. Verify the success message and that the new page is visible
    expect(page).to have_content(the_description)
    expect(page).to have_content(the_title)
    expect(page).to have_content(rtc)
    expect(page).to have_content("Page created successfully.")
  end

  scenario "READ - User can view a page with content blocks" do
    page_with_content_blocks = create(
      :aurelius_press_document_page,
      :with_one_of_each_content_block,
      title: "Test Page with One of Each Content Block Type",
      user: @user
    )
    # 1. Visit the show page
    visit aurelius_press_page_path(page_with_content_blocks)
    # 2. Verify the content blocks are displayed
    expect(page).to have_content("Test Page with One of Each Content Block Type")
    within(".content-blocks") do
      within(".rich-text-block") do
        expect(page).to have_css(".trix-content", count: 1)
      end
      within(".image-block") do
        expect(page).to have_css("img", count: 1)
      end
      within(".gallery-block") do
        # Verify that there are at least 2 images
        expect(page).to have_css("img", minimum: 2)
      end
      within(".video-embed-block") do
        expect(page).to have_css("iframe", count: 1)
      end
    end
  end

  scenario "UPDATE - User can update an existing content block" do
    # 1. Create a page with one of each content block type
    page_to_update = create(:aurelius_press_document_page, :with_one_of_each_content_block, user: @user)
    # 2. Visit the edit page for the existing content block
    visit edit_aurelius_press_page_path(page_to_update)

    html_id = "my-custom-updated-id"
    html_class = "my-custom-updated-class"
    data_attributes = "data-custom-attribute=\"my-custom-value\""
    rich_text_content = "Updated rich text content"
    # 4. Edit the page a little
    fill_in "* Title", with: "Updating this Page and the Content Block"
    fill_in "Subtitle", with: "This is the updated subtitle for the page."
    within(".content-block-rich-text-block-fields") do
      # 5. Edit the rich text content block
      fill_in "HTML ID", with: html_id
      fill_in "HTML Class", with: html_class
      fill_in "Data Attributes", with: data_attributes
      fill_in_rich_text_area "trix-content", with: rich_text_content
    end
    # 6. Submit the form
    click_button "Update"
    # 7. Verify the success message and that the updated page is visible
    expect(page).to have_content("Page updated successfully.")
    within(".content-blocks") do
      expect(page).to have_content(rich_text_content)
      expect(page).to have_css("##{html_id}")
      expect(page).to have_css(".#{html_class}")
      expect(page).to have_css("[#{data_attributes}]")
    end
  end

  scenario "DELETE - User can delete an existing content block" do
    # 1. Create a page with one of each content block type
    page_title = "Removing the Rich Text Content Block"
    page_to_update = create(
      :aurelius_press_document_page,
      :with_one_of_each_content_block,
      title: page_title,
      user: @user
    )
    # 2. Visit the edit page for the existing content block
    visit edit_aurelius_press_page_path(page_to_update)
    # 3. Remove the rich text content block
    within("#the-content-blocks .content-block-rich-text-block-fields") do
      click_button "Remove"
    end
    # 4. Submit the form
    click_button "Update"
    # 5. Verify the success message and that the updated page is visible
    expect(page).to have_content("Page updated successfully.")
    expect(page).not_to have_css(".rich-text-block")
  end
end
