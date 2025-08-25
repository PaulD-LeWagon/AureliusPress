require "rails_helper"

RSpec.feature "Admin can manage access to Pages", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:moderator) { create(:aurelius_press_moderator_user) }
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:superuser) { create(:aurelius_press_superuser_user) }

  let!(:pages) { create_list(:aurelius_press_document_page, 3, user: admin) }

  context "As a user with insufficient permissions - i.e. Reader or User" do
    let!(:existing_user) { create(:aurelius_press_user) }

    scenario "is denied access to the Pages index page" do
      [reader, user].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_pages_path
        # Assert that the page is redirected to the root path
        expect(current_path).to eq(root_path)
        # Assert that a flash message is shown
        expect(page).to have_content("You are not authorized to perform this action.")
        sign_out the_agent
      end
    end

    scenario "cannot create a new page" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit new_aurelius_press_admin_document_page_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot edit an existing page" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit edit_aurelius_press_admin_document_page_path(pages.sample)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot destroy an existing page" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_admin_document_page_path(pages.sample)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot perform bulk actions" do
      skip "Bulk actions are not permitted for regular users."
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_admin_document_pages_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end
  end

  context "As a power user: [Moderator, Admin, Superuser]" do
    scenario "can view the page management dashboard [INDEX PAGE]" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_pages_path
        expect(page).to have_content("AureliusPress::Admin::Document::Pages#index")
        expect(page).to have_content("View All Pages")
        expect(current_path).to eq(aurelius_press_admin_document_pages_path)
        sign_out the_agent
      end
    end

    scenario "can access the create a new page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit new_aurelius_press_admin_document_page_path
        expect(page).to have_content("AureliusPress::Admin::Document::Pages#new")
        expect(page).to have_content("Create New Page")
        expect(current_path).to eq(new_aurelius_press_admin_document_page_path)
        sign_out the_agent
      end
    end

    scenario "can access the edit page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit edit_aurelius_press_admin_document_page_path(pages.last)
        expect(page).to have_content("AureliusPress::Admin::Document::Pages#edit")
        expect(page).to have_content("Edit Page")
        expect(current_path).to eq(edit_aurelius_press_admin_document_page_path(pages.last))
        sign_out the_agent
      end
    end

    scenario "can access the show page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_page_path(pages.first)
        expect(page).to have_content("AureliusPress::Admin::Document::Pages#show")
        expect(current_path).to eq(aurelius_press_admin_document_page_path(pages.first))
        sign_out the_agent
      end
    end

    scenario "can access the delete route/path - i.e. delete a page." do
      [moderator, admin, superuser].each_with_index do |the_agent, index|
        sign_in the_agent
        visit aurelius_press_admin_document_page_path(pages[index])
        expect(current_path).to eq(aurelius_press_admin_document_page_path(pages[index]))
        accept_confirm do
          click_link "Delete"
        end
        expect(page).to have_content("Page deleted successfully.")
        sign_out the_agent
      end
    end

    scenario "can perform bulk actions" do
      skip "Bulk actions are not permitted for regular users."
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_pages_path
        expect(current_path).to eq(aurelius_press_admin_document_pages_path)
        # @todo: Implement bulk actions test
        sign_out the_agent
      end
    end
  end
end
