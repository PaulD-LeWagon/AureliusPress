require "rails_helper"

RSpec.feature "Author Public Access", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:std_users) { [reader, user] }
  let!(:author_1) { create(:aurelius_press_catalogue_author) }
  let!(:author_2) { create(:aurelius_press_catalogue_author) }

  scenario "Standard Users can view a list of all authors" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_authors_path
      
      expect(page).to have_content("Authors")
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Authors#index\"]")
      expect(page).to have_content(author_1.name)
      expect(page).to have_content(author_2.name)
      logout
    end
  end

  scenario "Standard Users can view an author's details" do
    std_users.each do |the_actor|
      login_as the_actor
      visit aurelius_press_catalogue_authors_path
      
      find("a[href='#{aurelius_press_catalogue_author_path(author_1)}']").click
      
      expect(page).to have_css("[template=\"AureliusPress::Catalogue::Authors#show\"]")
      expect(page).to have_content("Author #{author_1.name}")
      logout
    end
  end
end
