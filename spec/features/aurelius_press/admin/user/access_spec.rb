require "rails_helper"

RSpec.feature "Admin User Management Access" do
  before do
    @admin = create(:aurelius_press_admin_user)
    @reader = create(:aurelius_press_reader_user)
    @user = create(:aurelius_press_user)
    @moderator = create(:aurelius_press_moderator_user)
    @superuser = create(:aurelius_press_superuser_user)
  end

  after do
    @admin.destroy if @admin.persisted?
    @reader.destroy if @reader.persisted?
    @user.destroy if @user.persisted?
    @moderator.destroy if @moderator.persisted?
    @superuser.destroy if @superuser.persisted?
  end

  context "as a reader, user or moderator with insufficient permissions" do
    scenario "cannot view the user management dashboard" do
      [@reader, @user, @moderator].each do |the_actor|
        login_as the_actor
        visit aurelius_press_admin_users_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
      end
    end

    scenario "cannot create a new user" do
      [@reader, @user, @moderator].each do |the_actor|
        sign_in the_actor
        visit new_aurelius_press_admin_user_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
      end
    end

    scenario "cannot edit an existing user" do
      [@reader, @user, @moderator].each do |the_actor|
        sign_in the_actor
        visit edit_aurelius_press_admin_user_path(create(:aurelius_press_user))
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        accept_confirm do
          click_link "Logout"
        end
      end
    end

    scenario "cannot destroy an existing user" do
      [@reader, @user, @moderator].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_admin_user_path(create(:aurelius_press_user))
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
      end
    end
  end

  context "as an admin user" do
    before { sign_in @admin }
    after { sign_out @admin }

    scenario "can view the user management dashboard" do
      visit aurelius_press_admin_users_path
      expect(page).to have_content("Manage users of the AureliusPress application.")
    end

    scenario "can only see non-admin users on the dashboard" do
      another_admin = create(:aurelius_press_admin_user)
      visit aurelius_press_admin_users_path
      # The admin user should see readers, users and moderators only
      expect(page).to have_content(@reader.email)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@moderator.email)
      # The admin user should NOT see another admin or a superuser
      expect(page).not_to have_content(another_admin.email)
      expect(page).not_to have_content(@superuser.email)
    end

    scenario "can create a new user" do
      visit new_aurelius_press_admin_user_path
      fill_in "First name", with: Faker::Name.first_name
      fill_in "Last name", with: Faker::Name.last_name
      fill_in "Email", with: Faker::Internet.email
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      select "User", from: "Role"
      click_button "Create"
      expect(page).to have_content("User was successfully created.")
    end

    scenario "can edit a regular user" do
      updated_name = "Updated #{Faker::Name.first_name}"
      visit edit_aurelius_press_admin_user_path(@user)
      fill_in "First name", with: updated_name
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@user.reload.first_name).to eq(updated_name)
    end

    scenario "cannot view the edit page of another admin user" do
      another_admin = create(:aurelius_press_admin_user)
      visit edit_aurelius_press_admin_user_path(another_admin)
      expect(page).to have_content("You are not authorized to perform this action.")
      expect(current_path).to eq(root_path)
    end

    scenario "cannot view the show page of another admin user" do
      another_admin = create(:aurelius_press_admin_user)
      visit aurelius_press_admin_user_path(another_admin)
      expect(page).to have_content("You are not authorized to perform this action.")
      expect(current_path).to eq(root_path)
    end

    scenario "can change a user's role to a lower or equal role" do
      visit edit_aurelius_press_admin_user_path(@user)
      select "Moderator", from: "Role"
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@user.reload.role).to eq("moderator")
    end

    scenario "cannot upgrade a user's role to that of admin or higher (only superusers can do this)" do
      visit edit_aurelius_press_admin_user_path(@user)
      # Assert that the dropdown contains the correct options
      expect(page).to have_select("Role", with_options: ["Reader", "User", "Moderator"])
      # Assert that the dropdown does NOT contain the restricted roles
      expect(page).to have_no_select("Role", with_options: ["Admin", "Superuser"])
      # Verify that the user cannot be upgraded
      select "Moderator", from: "Role"
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@user.reload.role).to eq("moderator")
    end
  end

  context "as a superuser" do
    before { sign_in @superuser }
    after { sign_out @superuser }

    scenario "can view the user management dashboard" do
      visit aurelius_press_admin_users_path
      expect(page).to have_content("Manage users of the AureliusPress application.")
    end

    scenario "can edit a regular user" do
      visit edit_aurelius_press_admin_user_path(@user)
      fill_in "First name", with: "SuperUpdated"
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@user.reload.first_name).to eq("SuperUpdated")
    end

    scenario "can destroy a regular user" do
      visit edit_aurelius_press_admin_user_path(@user)
      accept_confirm do
        click_link "Delete"
      end
      expect(page).to have_content("User was successfully destroyed.")
    end

    scenario "can also edit an admin user" do
      visit edit_aurelius_press_admin_user_path(@admin)
      fill_in "First name", with: "SuperUpdatedAdmin"
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@admin.reload.first_name).to eq("SuperUpdatedAdmin")
    end

    scenario "can destroy an admin user" do
      visit edit_aurelius_press_admin_user_path(@admin)
      accept_confirm do
        click_link "Delete"
      end
      expect(page).to have_content("User was successfully destroyed.")
    end

    scenario "can change a user's role to any role" do
      visit edit_aurelius_press_admin_user_path(@user)
      select "Admin", from: "Role"
      click_button "Update"
      expect(page).to have_content("User was successfully updated.")
      expect(@user.reload.role).to eq("admin")
    end

    scenario "can not see other superusers on the dashboard" do
      another_superuser = create(:aurelius_press_superuser_user)
      visit aurelius_press_admin_users_path
      # The @admin user should see @readers, users and moderators only
      expect(page).to have_content(@reader.email)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@moderator.email)
      expect(page).to have_content(@admin.email)
      # A @superuser should NOT see another @superuser
      expect(page).not_to have_content(another_superuser.email)
    end
  end
end
