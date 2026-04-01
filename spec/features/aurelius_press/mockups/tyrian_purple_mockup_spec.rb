require "rails_helper"

RSpec.feature "Tyrian Purple UI Mockup", type: :feature, js: true do
  scenario "User visits the Tyrian Purple mockup page" do
    visit "/mockups/tyrian_purple"

    expect(page).to have_content("The Art of Deep Thought")
    expect(page).to have_content("Tyrian Purple")
    
    # Check for the primary brand color in the CTA button
    # Using evaluate_script for more reliable cross-driver CSS checking
    bg_color = page.evaluate_script("window.getComputedStyle(document.querySelector('.btn-primary')).backgroundColor")
    expect(bg_color).to eq("rgb(102, 2, 60)") # #66023C
  end

  scenario "Mockup is responsive" do
    visit "/mockups/tyrian_purple"

    # Mobile view
    page.driver.browser.manage.window.resize_to(375, 812)
    # Ensure the layout has time to respond
    expect(page).to have_css(".mobile-menu-toggle", visible: true, wait: 5)

    # Desktop view
    page.driver.browser.manage.window.resize_to(1440, 900)
    expect(page).to have_css(".desktop-nav", visible: true, wait: 5)
  end
end
