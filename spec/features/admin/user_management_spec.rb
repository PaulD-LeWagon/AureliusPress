require "rails_helper"

def login_as(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

RSpec.feature "Admin can manage users (CRUD)", :js do
  let!(:admin_user) { create(:aurelius_press_admin_user) }
  let!(:regular_user) { create(:aurelius_press_user) }

  scenario "CREATE - Admin can create a new user" do
    # 1. Log in as an admin user
    login_as admin_user
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
      select "moderator", from: "Role"
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
    login_as admin_user
    # 2. Navigate to the admin users index page
    visit aurelius_press_admin_users_path
    # 3. Verify that the admin sees a list of users
    expect(page).to have_content "Users"
    expect(page).to have_content admin_user.email
    expect(page).to have_content regular_user.email
    expect(page).to have_link "New User", href: new_aurelius_press_admin_user_path
  end

  scenario "UPDATE - Admin can edit an existing user" do
    # 1. Log in as an admin user
    login_as admin_user

    # 2. Navigate to the user's edit page
    visit aurelius_press_admin_users_path
    click_link "Edit", href: edit_aurelius_press_admin_user_path(regular_user)

    # 3. Fill in the form with new attributes and submit
    expect(page).to have_content "Edit User"

    # Define the new values for the user
    new_first_name = "Jane"
    new_last_name = "Smith"
    new_username = "jane-smith"
    new_email = "jane.smith@example.com"
    new_role = "moderator"
    new_bio = "Jane Smith is a new moderator for Aurelius Press."

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
    expect(page).to have_current_path(aurelius_press_admin_user_path(regular_user))

    # Verify the updated content is displayed on the page
    expect(page).to have_content new_first_name
    expect(page).to have_content new_last_name
    expect(page).to have_content new_username
    expect(page).to have_content new_email
    expect(page).to have_content new_role
    expect(page).to have_content new_bio
    expect(page).to have_css("img[src*='test_image.png']")

    # Reload the user from the database to ensure it was updated
    regular_user.reload
    # Verify the user object was updated in the database
    expect(regular_user.first_name).to eq new_first_name
    expect(regular_user.last_name).to eq new_last_name
    expect(regular_user.username).to eq new_username
    expect(regular_user.email).to eq new_email
    expect(regular_user.role).to eq new_role
  end

  scenario "DELETE - Admin can delete a user" do
    # 1. Log in as an admin user
    login_as admin_user

    # 2. Navigate to the admin users index page
    visit aurelius_press_admin_users_path

    # 3. Verify that the admin sees a list of users
    expect(page).to have_content regular_user.email
    expect(AureliusPress::User.count).to eq(2)

    # 4. Click the delete link for the regular user and confirm
    accept_confirm do
      click_link "Delete", href: aurelius_press_admin_user_path(regular_user)
    end

    # 5. Verify the user was deleted successfully
    expect(page).to have_content "User was successfully destroyed."
    expect(page).to have_current_path(aurelius_press_admin_users_path)
    expect(page).not_to have_content regular_user.email
    expect(AureliusPress::User.count).to eq(1)
  end
end
