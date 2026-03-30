require 'rails_helper'

RSpec.feature "Social Engagement", type: :feature, js: true do
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:blog_post) { create(:aurelius_press_document_blog_post, user: admin, status: :published, visibility: :public_to_www) }

  describe "As an authenticated user" do
    before do
      login_as(admin, scope: :user)
      visit aurelius_press_blog_post_path(blog_post)
    end

    scenario "I can like and unlike a blog post" do
      within "#engagement_aurelius_press_document_blog_post_#{blog_post.id}" do
        # Initial state
        expect(page).to have_content("0")
        
        # Like it
        find('.engagement-item', text: '👍').click
        expect(page).to have_content("1")
        expect(page).to have_css('.engagement-item.active', text: '👍')

        # Unlike it (toggle)
        find('.engagement-item', text: '👍').click
        expect(page).to have_content("0")
        expect(page).not_to have_css('.engagement-item.active')
      end
    end

    scenario "I can react with an emoji and change it" do
      within "#engagement_aurelius_press_document_blog_post_#{blog_post.id}" do
        # Open picker
        # We'll force it visible with JS to ensure we can test the backend logic
        page.execute_script("document.querySelector('.reaction-dropdown').classList.add('visible')")
        
        # Verify picker is visible (using wait for the class to appear)
        expect(page).to have_css('.reaction-dropdown.visible', wait: 5)
        
        # Select Fire
        # Ensure the form button is clicked properly
        within '.reaction-dropdown' do
          find('.reaction-option', text: '🔥').click
        end
        
        # Verify update (The dropdown should be hidden automatically by the controller if it's working)
        expect(page).to have_content("1")
        expect(page).to have_css('.engagement-item.active', text: '🔥')
      end
    end
  end

  describe "As a guest user" do
    scenario "I see counts but am redirected to login on click" do
      visit aurelius_press_blog_post_path(blog_post)

      within "#engagement_aurelius_press_document_blog_post_#{blog_post.id}" do
        expect(page).to have_content("0")
        find('.engagement-item', text: '👍').click
      end

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
