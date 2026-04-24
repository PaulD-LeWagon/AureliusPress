require "rails_helper"

RSpec.describe "Admin Taxonomy Search-Select", type: :feature, js: true do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:tag_stoicism) { create(:aurelius_press_taxonomy_tag, name: "Stoicism") }
  let!(:blog_post) { create(:aurelius_press_document_blog_post, title: "Initial Post") }

  before do
    login_as(admin, scope: :user)
    visit edit_aurelius_press_admin_document_blog_post_path(blog_post)
  end

  describe "Searching and Selecting Tags" do
    it "allows searching and selecting an existing tag" do
      # Targeted find by ID to ensure we hit the new component
      find("#tag-search-input").set("Stoi")
      
      # Wait for AJAX and results to appear
      expect(page).to have_css(".taxonomy-search-results", visible: true)
      expect(page).to have_content("Stoicism")
      
      # Select the tag by name explicitly
      find(".search-result-item", text: "Stoicism").click
      
      # Verify it's in the selection list - scoped to the parent container
      within find(".taxonomy-search-container", text: "Tags") do
        within ".taxonomy-selection-list" do
          expect(page).to have_content("Stoicism")
        end
      end
    end

    it "allows creating a new tag on the fly with a button" do
      # Type the new tag name
      find("#tag-search-input").send_keys("Modern Stoicism")
      
      # Wait for search to trigger and show "No matches"
      expect(page).to have_content("No matches found", wait: 5)
      
      # Click Add button to create
      within find(".taxonomy-search-container", text: "Tags") do
        click_on "Add"
      end
      
      # Verify it's added to the selection
      within find(".taxonomy-search-container", text: "Tags") do
        expect(page).to have_content("Modern Stoicism", wait: 5)
      end
      
      expect(AureliusPress::Taxonomy::Tag.find_by(name: "Modern Stoicism")).to be_present
    end

    it "allows creating a new category on the fly with a button" do
      # Type the new category name
      find("#category-search-input").send_keys("Philosophy")
      
      # Wait for search to trigger and show "No matches"
      expect(page).to have_content("No matches found", wait: 5)
      
      # Click Add button to create
      within find(".taxonomy-search-container", text: "Categories") do
        click_on "Add"
      end
      
      # Verify it's added to the selection
      within find(".taxonomy-search-container", text: "Categories") do
        expect(page).to have_content("Philosophy", wait: 5)
      end
      
      expect(AureliusPress::Taxonomy::Category.find_by(name: "Philosophy")).to be_present

      # Verify it associates correctly with the Blog Post explicitly on form submission
      click_button "Update"
      
      # Now verify the blog post has the categories and tags
      expect(page).to have_content("Show Blog Post") # Wait for page redirect to show page
      expect(blog_post.reload.categories.pluck(:name)).to include("Philosophy")
    end
  end
end
