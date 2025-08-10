require "rails_helper"

RSpec.feature "Admin can manage a Page (CRUD)", :js do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:page_one) { create(:aurelius_press_document_page, title: "First Page", content: "Content of the first page.") }
  let!(:page_two) { create(:aurelius_press_document_page, title: "Second Page", content: "Content of the second page.") }

  scenario "READ - Admin can view a list of all pages" do
    # 1. Log in as an admin using Devise helper
    sign_in admin
    # 2. Navigate to the admin pages index page
    visit aurelius_press_admin_pages_path
    # 3. Verify that the admin can see the page titles and content
    expect(page).to have_content("Pages")
    expect(page).to have_link("New Page", href: new_aurelius_press_admin_page_path)
    # 4. Assert that both pages created by FactoryBot are visible
    expect(page).to have_content(page_one.title)
    expect(page).to have_content(page_one.content.to_plain_text)
    expect(page).to have_content(page_two.title)
    expect(page).to have_content(page_two.content.to_plain_text)
  end
end
