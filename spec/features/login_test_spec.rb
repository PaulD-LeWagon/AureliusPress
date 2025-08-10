require "rails_helper"

RSpec.feature "Login Test" do
  let!(:user) { create(:aurelius_press_user) }

  scenario "user can log in successfully" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Signed in successfully.")
    click_link "Logout"
  end
end
