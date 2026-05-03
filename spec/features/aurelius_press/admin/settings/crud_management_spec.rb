require "rails_helper"

RSpec.feature "Admin can manage site settings", :js do
  let!(:admin)     { create(:aurelius_press_admin_user) }
  let!(:superuser) { create(:aurelius_press_superuser_user) }
  let!(:user)      { create(:aurelius_press_user) }

  before do
    AureliusPress::SiteSetting.create!(key: "site_name",        value: "AureliusPress", value_type: "string",  description: "The public name of the site")
    AureliusPress::SiteSetting.create!(key: "registration_open", value: "true",          value_type: "boolean", description: "Allow new registrations")
  end

  # ── INDEX ──────────────────────────────────────────────────────────────────

  scenario "READ - admin can view all settings" do
    sign_in admin
    visit aurelius_press_admin_settings_path

    expect(page).to have_content("Site Settings")
    expect(page).to have_content("site_name")
    expect(page).to have_content("AureliusPress")
    expect(page).to have_content("registration_open")
  end

  scenario "READ - superuser can view all settings" do
    sign_in superuser
    visit aurelius_press_admin_settings_path

    expect(page).to have_content("site_name")
  end

  scenario "READ - regular user is redirected away" do
    sign_in user
    visit aurelius_press_admin_settings_path

    expect(page).not_to have_content("Site Settings")
    expect(page).to have_content("You are not authorized to perform this action.")
  end

  # ── EDIT / UPDATE ──────────────────────────────────────────────────────────

  scenario "UPDATE - admin can edit a string setting" do
    sign_in admin
    visit aurelius_press_admin_settings_path

    within("tr", text: "site_name") do
      click_link "Edit"
    end

    expect(page).to have_content("Edit Setting")
    fill_in "Value", with: "My Custom Site"
    click_button "Update"

    expect(page).to have_current_path(aurelius_press_admin_settings_path)
    expect(AureliusPress::SiteSetting.get("site_name")).to eq("My Custom Site")
  end

  scenario "UPDATE - admin can edit a boolean setting" do
    sign_in admin
    visit aurelius_press_admin_settings_path

    within("tr", text: "registration_open") do
      click_link "Edit"
    end

    select "No", from: "Enabled"
    click_button "Update"

    expect(page).to have_current_path(aurelius_press_admin_settings_path)
    expect(AureliusPress::SiteSetting.find_by(key: "registration_open").value).to eq("false")
  end
end
