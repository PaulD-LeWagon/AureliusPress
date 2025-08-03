require "rails_helper"

RSpec.feature "Admin can manage users" do
  let!(:admin_user) { create(:aurelius_press_admin_user) }
  let!(:regular_user) { create(:aurelius_press_user) }

  scenario "Admin can view a list of all users" do
    # 1. Log in as an admin user using Devise routes
    visit new_user_session_path

    # save_and_open_page

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: admin_user.password
    click_button "Log in"

    # 2. Navigate to the admin users index page
    visit aurelius_press_admin_users_path

    # 3. Verify that the admin sees a list of users
    expect(page).to have_content "Users"
    expect(page).to have_content admin_user.email
    expect(page).to have_content regular_user.email
    expect(page).to have_link "New User", href: new_aurelius_press_admin_user_path
  end

  fscenario "Admin can create a new user" do
    # 1. Log in as an admin user
    visit new_user_session_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: admin_user.password
    click_button "Log in"

    # 2. Navigate to the new user page via the index page
    visit aurelius_press_admin_users_path
    click_link "New User"

    # 3. Fill in the form with valid attributes and submit
    expect(page).to have_content "New User"

    expect {
      save_and_open_page

      fill_in "First name", with: "Yvonne"
      fill_in "Last name", with: "Amores-Cabrera"
      fill_in "Username", with: "inday-ibon-cabrera"
      fill_in "Email", with: "yvonne.amores-cabrera@the-aurelius-press.com"
      fill_in "Password", with: "devanney"
      fill_in "Password confirmation", with: "devanney"
      select "editor", from: "Role"
      select "active", from: "Status"
      fill_in_rich_text_area "Bio", with: "This is Yvonne's bio."
      attach_file "Avatar", Rails.root.join("spec/fixtures/files/avatar.png")

      # 4. Submit the form
      click_button "Create User"
    }.to change(AureliusPress::User, :count).by(1)

    # 4. Verify successful creation and redirection
    new_user = AureliusPress::User.last
    expect(page).to have_content "User was successfully created."
    expect(page).to have_current_path(aurelius_press_admin_user_path(new_user))
    expect(page).to have_content new_user.email
    expect(page).to have_content new_user.name
    expect(page).to have_content new_user.role
  end
end
