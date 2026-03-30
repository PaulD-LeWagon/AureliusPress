require "rails_helper"

RSpec.feature "Quote Public Access", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:std_users) { [reader, user] }
  let!(:quote_1) { create(:aurelius_press_catalogue_quote) }
  let!(:quote_2) { create(:aurelius_press_catalogue_quote) }

  scenario "Standard Users can view a list of all quotes" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_quotes_path
      
      expect(page).to have_content("Quotes")
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Quotes#index\"]")
      expect(page).to have_content(quote_1.text.truncate(50))
      expect(page).to have_content(quote_2.text.truncate(50))
      logout
    end
  end

  scenario "Standard Users can view a quote's details" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_quotes_path
      
      find("a[href='#{aurelius_press_catalogue_quote_path(quote_1)}']").click
      
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Quotes#show\"]")
      expect(page).to have_content("Quote #{quote_1.id}")
      expect(page).to have_content(quote_1.text)
      logout
    end
  end
end
