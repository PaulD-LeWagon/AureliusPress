require "rails_helper"

def login_as(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

RSpec.feature "Admin can manage users (CRUD)", :js do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:moderator) { create(:aurelius_press_moderator_user) }

  scenario "CREATE - Admin can create a new user" do
    # 1. Log in as an admin user
    login_as admin
    # 2. Navigate to the new user page via the index page
    visit aurelius_press_admin_users_path
    click_link "New User"
    # 3. Fill in the form with valid attributes and submit
    expect(page).to have_content "New User"
    expect {
      fill_in "First name", with: "Yvonne"
      fill_in "Last name", with: "Amores-Cabrera"
      fill_in "Username", with: "inday-ibon-cabrera"
      fill_in "Email", with: "yvonne.amores-cabrera@the-aurelius-press.com"
      fill_in "Password", with: "devanney"
      fill_in "Password confirmation", with: "devanney"
      select "Moderator", from: "Role"
      select "active", from: "Status" # aurelius_press_user_bio_trix_input_aurelius_press_user
      fill_in_rich_text_area "trix_bio_id", with: "This is Yvonne's bio."
      attach_file "Avatar", Rails.root.join(
        "spec",
        "fixtures",
        "files",
        "test_avatar.png"
      )
      # save_and_open_page
      # 4. Submit the form
      click_button "Create User"
    }.to change(AureliusPress::User, :count).by(1)
    # 4. Verify successful creation and redirection
    new_user = AureliusPress::User.last
    expect(page).to have_content "User was successfully created."
    expect(page).to have_current_path(aurelius_press_admin_user_path(new_user))
    expect(page).to have_content new_user.email
    expect(page).to have_content new_user.full_name
    expect(page).to have_content new_user.username
    expect(page).to have_content new_user.status
    expect(page).to have_content new_user.role
    expect(page).to have_content "This is Yvonne's bio."
    expect(page).to have_css("img[src*='test_avatar.png']")
  end

  scenario "READ - Admin can view a list of all users" do
    # 1. Log in as an admin user using Devise routes
    visit new_user_session_path
    # save_and_open_page
    login_as admin
    # 2. Navigate to the admin users index page
    visit aurelius_press_admin_users_path
    # 3. Verify that the admin sees a list of users
    expect(page).to have_content "Users"
    expect(page).to have_content reader.email
    expect(page).to have_content user.email
    expect(page).to have_content moderator.email
    expect(page).to have_link "New User", href: new_aurelius_press_admin_user_path
  end

  scenario "UPDATE - Admin can edit an existing user" do
    # 1. Log in as an admin user
    login_as admin

    # 2. Navigate to the user's edit page
    visit aurelius_press_admin_users_path
    click_link "Edit", href: edit_aurelius_press_admin_user_path(user)

    # 3. Fill in the form with new attributes and submit
    expect(page).to have_content "Edit User"

    # Define the new values for the user
    new_first_name = "Jane"
    new_last_name = "Smith"
    new_username = "jane-smith"
    new_email = "jane.smith@example.com"
    new_role = "Moderator"
    new_bio = "Jane Smith is a new Moderator for Aurelius Press."

    # Fill in the form fields with the new data
    fill_in "First name", with: new_first_name
    fill_in "Last name", with: new_last_name
    fill_in "Username", with: new_username
    fill_in "Email", with: new_email
    select new_role, from: "Role"
    # aurelius_press_user_bio_trix_input_aurelius_press_user_2
    fill_in_rich_text_area "trix_bio_id", with: new_bio
    attach_file "Avatar", Rails.root.join(
      "spec",
      "fixtures",
      "files",
      "test_image.png"
    )
    # save_and_open_page
    # 4. Submit the form
    click_button "Update User"

    # 5. Verify the user was updated successfully and redirected to the show page
    expect(page).to have_content "User was successfully updated."
    expect(page).to have_current_path(aurelius_press_admin_user_path(user))

    # Verify the updated content is displayed on the page
    expect(page).to have_content new_first_name
    expect(page).to have_content new_last_name
    expect(page).to have_content new_username
    expect(page).to have_content new_email
    expect(page).to have_content new_role
    expect(page).to have_content new_bio
    expect(page).to have_css("img[src*='test_image.png']")

    # Reload the user from the database to ensure it was updated
    user.reload
    # Verify the user object was updated in the database
    expect(user.first_name).to eq new_first_name
    expect(user.last_name).to eq new_last_name
    expect(user.username).to eq new_username
    expect(user.email).to eq new_email
    expect(user.role).to eq new_role.downcase
  end

  scenario "DELETE - Admin can delete a user" do
    # 1. Log in as an admin user
    login_as admin
    # 2. Navigate to the admin users index page
    visit aurelius_press_admin_users_path
    # 3. Verify that the admin sees a list of users
    expect(page).to have_content user.email
    expect(AureliusPress::User.count).to eq(4)
    # 4. Click the delete link for the regular user and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_admin_user_path(user)
    end
    # 5. Verify the user was deleted successfully
    expect(page).to have_content "User was successfully destroyed."
    expect(page).to have_current_path(aurelius_press_admin_users_path)
    expect(page).not_to have_content user.email
    expect(AureliusPress::User.count).to eq(3)
  end

  scenario "BULK Operations - An admin can perform bulk actions on users" do
    skip "Implement bulk actions scenario"
    # # 1. Log in as an admin user
    # login_as admin
    # # 2. Navigate to the admin users index page
    # visit aurelius_press_admin_users_path
    # # 3. Select multiple users for bulk actions
    # check "user_ids[]", option: user.id
    # check "user_ids[]", option: another_user.id
    # # 4. Choose a bulk action from the dropdown
    # select "Delete Selected Users", from: "bulk_action"
    # # 5. Confirm the bulk action
    # accept_confirm do
    #   click_button "Apply"
    # end
    # # 6. Verify the users were deleted successfully
    # expect(page).to have_content "Users were successfully destroyed."
    # expect(page).to have_current_path(aurelius_press_admin_users_path)
    # expect(page).not_to have_content user.email
    # expect(page).not_to have_content another_user.email
    # expect(AureliusPress::User.count).to eq(0)
  end
end
