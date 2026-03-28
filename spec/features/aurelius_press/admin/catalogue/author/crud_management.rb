require "rails_helper"

RSpec.feature "Admin can manage a Page (CRUD)", :js do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:author_one) { create(:aurelius_press_catalogue_author, name: "First Author", bio: "Bio of the first author.") }
  let!(:author_two) { create(:aurelius_press_catalogue_author, name: "Second Author", bio: "Bio of the second author.") }

  scenario "CREATE - Admin can create a new author" do
    # 1. Log in as an admin
    sign_in admin
    # 2. Visit the new author form
    visit new_aurelius_press_admin_catalogue_author_path
    # 3. Fill out the form with valid data
    name = "James RR Tolkien"
    bio = "British writer, poet, philologist, and academic, best known for his high-fantasy works."
    fill_in "Name", with: name
    fill_in_rich_text_area "Bio", with: bio
    # 4. Submit the form
    click_button "Create"
    # save_and_open_page
    # 5. Verify the success message and that the new author is visible
    expect(page).to have_content("Author created successfully.")
    expect(page).to have_content(name)
    expect(page).to have_content(bio)
  end

  scenario "READ - Admin can view a list of all authors" do
    # 1. Log in as an admin using Devise helper
    sign_in admin
    # 2. Navigate to the admin authors index page
    visit aurelius_press_admin_catalogue_authors_path
    # 3. Verify that the admin can see the author names and bios
    expect(page).to have_content("Authors")
    expect(page).to have_link("New Author", href: new_aurelius_press_admin_catalogue_author_path)
    # 4. Assert that both authors created by FactoryBot are visible
    expect(page).to have_content(author_one.name)
    expect(page).to have_content(author_one.bio.truncate(25).squish)
    expect(page).to have_content(author_two.name)
    expect(page).to have_content(author_two.bio.truncate(25).squish)
  end

  scenario "UPDATE - Admin can edit an existing author" do
    # Create an author to be edited
    # author_to_edit = create(:aurelius_press_catalogue_author, user: admin, name: "Original Name", bio: "Original bio.")
    # Log in as an admin
    sign_in admin
    # Navigate to the edit author page
    visit edit_aurelius_press_admin_catalogue_author_path(author_one)
    # Define the new attributes
    new_name = "Updated Author Name"
    new_bio = "Updated bio."
    # Fill out the form with the new data
    fill_in "Name", with: new_title
    fill_in_rich_text_area "Bio", with: new_description
    # Submit the form
    click_button "Update"
    # Verify the success message and that the changes are visible on the show page
    expect(page).to have_content("Author updated successfully.")
    expect(page).to have_content(new_name)
    expect(page).to have_content(new_bio)
  end

  scenario "DELETE - Admin can delete an Author" do
    # 1. Log in as an admin user
    sign_in admin
    # 2. Navigate to the admin authors index page
    visit aurelius_press_admin_catalogue_authors_path
    # 3. Verify that the admin sees a list of authors
    expect(page).to have_content author_one.name
    expect(page).to have_content author_one.bio.truncate(25).squish
    expect(page).to have_content author_two.name
    expect(page).to have_content author_two.bio.truncate(25).squish
    expect(AureliusPress::Catalogue::Author.count).to eq(2)
    # 4. Click the delete link for the first author and confirm
    accept_turbo_confirm do
      click_link "Delete", href: aurelius_press_admin_catalogue_author_path(author_one)
    end
    # 5. Verify the author was deleted successfully
    expect(page).to have_content "Author deleted successfully."
    expect(page).to have_current_path(aurelius_press_admin_catalogue_authors_path)
    expect(page).not_to have_content author_one.name
    expect(AureliusPress::Catalogue::Author.count).to eq(1)
  end

  scenario "BULK Operations - An admin can perform bulk actions on Authors" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an admin user
    # # 2. Navigate to the pages index page
    # # 3. Select multiple pages for bulk actions
    # # 4. Choose a bulk action from the dropdown
    # # 5. Confirm the bulk action
    # # 6. Verify the pages were deleted successfully
  end
end
