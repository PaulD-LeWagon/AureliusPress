require "rails_helper"

RSpec.feature "User can access Pages Section", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:pages) { create_list(:aurelius_press_document_page, 3, user: user, visibility: :public_to_www, status: :published) }
  let!(:someone_elses_pages) { create_list(:aurelius_press_document_page, 3, visibility: :public_to_www, status: :published) }

  context "As a user with role [:reader]" do
    scenario "can access the Pages index page" do
      [reader].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_pages_path
        # Assert that the page is the index path
        expect(current_path).to eq(aurelius_press_pages_path)
        expect(page).to have_content("Pages")
        sign_out the_agent
      end
    end

    scenario "can access the #show page" do
      [reader].each do |the_agent|
        sign_in the_agent
        path = aurelius_press_page_path(pages.first)
        visit path
        expect(current_path).to eq(path)
        expect(page).to have_content(pages.first.title)
        sign_out the_agent
      end
    end

    scenario "cannot access the #edit page" do
      [reader].each do |the_agent|
        sign_in the_agent
        visit edit_aurelius_press_page_path(pages.first)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_agent
      end
    end

    scenario "cannot access the #new page" do
      [reader].each do |the_agent|
        sign_in the_agent
        visit new_aurelius_press_page_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_agent
      end
    end

    scenario "cannot access the #delete action" do
      [reader].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_page_path(someone_elses_pages.first)
        expect(page).to have_content(someone_elses_pages.first.title)
        accept_confirm do
          click_link "Delete"
        end
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_agent
      end
    end

    scenario "cannot access the #bulk_edit page" do
      skip "Bulk actions are not permitted for readers."
      [reader].each do |the_agent|
        sign_in the_agent

        sign_out the_agent
      end
    end
  end

  context "As a user with role [:user]" do
    scenario "can access the Pages index page" do
      [user].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_pages_path
        # Assert that the page is the index path
        expect(current_path).to eq(aurelius_press_pages_path)
        expect(page).to have_content("Pages")
        expect(page).to have_content(pages.first.title)
        expect(page).to have_content(someone_elses_pages.first.title)
        sign_out the_agent
      end
    end

    scenario "can access the #create page" do
      [user].each do |the_actor|
        sign_in the_actor
        visit new_aurelius_press_page_path
        expect(page).to have_content("New Page")
        expect(current_path).to eq(new_aurelius_press_page_path)
        sign_out the_actor
      end
    end

    scenario "can access the #edit page" do
      [user].each do |the_actor|
        sign_in the_actor
        visit edit_aurelius_press_page_path(pages.second)
        expect(page).to have_content("Edit Page")
        expect(current_path).to eq(edit_aurelius_press_page_path(pages.second))
        sign_out the_actor
      end
    end

    scenario "can delete an existing page" do
      [user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_page_path(pages.last)
        expect(page).to have_content(pages.last.title)
        accept_confirm do
          click_link "Delete"
        end
        expect(page).to have_content("Page deleted successfully.")
        sign_out the_actor
      end
    end

    scenario "can access and perform bulk actions" do
      skip "Bulk actions users not yet implemented."
      [user].each do |the_actor|
        sign_in the_actor

        sign_out the_actor
      end
    end

    scenario "cannot edit another user's page" do
      [user].each do |the_actor|
        sign_in the_actor
        visit edit_aurelius_press_page_path(someone_elses_pages.first)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot delete another user's page" do
      [user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_page_path(someone_elses_pages.first)
        expect(page).to have_content(someone_elses_pages.first.title)
        expect(page).to have_content(someone_elses_pages.first.user.full_name)
        accept_confirm do
          click_link "Delete"
        end
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end
  end
end
