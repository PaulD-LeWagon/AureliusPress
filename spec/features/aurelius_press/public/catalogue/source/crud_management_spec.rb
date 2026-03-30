require "rails_helper"

RSpec.feature "Source Public Access", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:std_users) { [reader, user] }
  let!(:source_1) { create(:aurelius_press_catalogue_source) }
  let!(:source_2) { create(:aurelius_press_catalogue_source) }

  scenario "Standard Users can view a list of all sources" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_sources_path
      
      expect(page).to have_content("Sources")
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Source#index\"]")
      expect(page).to have_content(source_1.title)
      expect(page).to have_content(source_2.title)
      logout
    end
  end

  scenario "Standard Users can view a source's details" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_sources_path
      
      find("a[href='#{aurelius_press_catalogue_source_path(source_1)}']").click
      
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Source#show\"]")
      expect(page).to have_content("Source #{source_1.title}")
      expect(page).to have_content(source_1.title)
      logout
    end
  end
end
