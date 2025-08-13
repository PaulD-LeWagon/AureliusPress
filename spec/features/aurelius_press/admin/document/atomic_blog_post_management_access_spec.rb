require "rails_helper"

RSpec.feature "Admin can manage access to Atomic Blog Posts", type: :feature, js: true do
  let!(:reader) { create(:aurelius_press_reader_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:moderator) { create(:aurelius_press_moderator_user) }
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:superuser) { create(:aurelius_press_superuser_user) }

  let!(:posts) { create_list(:aurelius_press_document_atomic_blog_post, 3, user: admin) }

  context "As a user with insufficient permissions - i.e. Reader or User" do
    scenario "is denied access to the Blog Posts index page" do
      [reader, user].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_atomic_blog_posts_path
        # Assert that the page is redirected to the root path
        expect(current_path).to eq(root_path)
        # Assert that a flash message is shown
        expect(page).to have_content("You are not authorized to perform this action.")
        sign_out the_agent
      end
    end

    scenario "cannot access the create a new post page" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit new_aurelius_press_admin_document_atomic_blog_post_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot edit an existing post" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit edit_aurelius_press_admin_document_atomic_blog_post_path(posts.sample)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot destroy an existing post" do
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_admin_document_atomic_blog_post_path(posts.sample)
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end

    scenario "cannot perform bulk actions" do
      skip "Bulk actions are not permitted for regular users."
      [reader, user].each do |the_actor|
        sign_in the_actor
        visit aurelius_press_admin_document_atomic_blog_posts_path
        expect(page).to have_content("You are not authorized to perform this action.")
        expect(current_path).to eq(root_path)
        sign_out the_actor
      end
    end
  end

  context "As a power user: [Moderator, Admin, Superuser]" do
    scenario "can view the Blog Posts management dashboard [INDEX PAGE]" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_atomic_blog_posts_path
        expect(page).to have_content("AureliusPress::Admin::Document::AtomicBlogPosts#index")
        expect(page).to have_content("View All Atomic Blog Posts")
        expect(current_path).to eq(aurelius_press_admin_document_atomic_blog_posts_path)
        sign_out the_agent
      end
    end

    scenario "can access the create a new post page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit new_aurelius_press_admin_document_atomic_blog_post_path
        expect(page).to have_content("AureliusPress::Admin::Document::AtomicBlogPosts#new")
        expect(page).to have_content("Create New Atomic Blog Post")
        expect(current_path).to eq(new_aurelius_press_admin_document_atomic_blog_post_path)
        sign_out the_agent
      end
    end

    scenario "can access the edit page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit edit_aurelius_press_admin_document_atomic_blog_post_path(posts.last)
        expect(page).to have_content("AureliusPress::Admin::Document::AtomicBlogPosts#edit")
        expect(page).to have_content("Edit Atomic Blog Post")
        expect(current_path).to eq(edit_aurelius_press_admin_document_atomic_blog_post_path(posts.last))
        sign_out the_agent
      end
    end

    scenario "can access the show page" do
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_atomic_blog_post_path(posts.first)
        expect(page).to have_content("AureliusPress::Admin::Document::AtomicBlogPosts#show")
        expect(page).to have_content(posts.first.title)
        expect(current_path).to eq(aurelius_press_admin_document_atomic_blog_post_path(posts.first))
        sign_out the_agent
      end
    end

    scenario "can access the delete route/path - i.e. delete a post." do
      [moderator, admin, superuser].each_with_index do |the_agent, index|
        sign_in the_agent
        visit aurelius_press_admin_document_atomic_blog_post_path(posts[index])
        expect(current_path).to eq(aurelius_press_admin_document_atomic_blog_post_path(posts[index]))
        accept_confirm do
          click_link "Delete"
        end
        expect(page).to have_content("Atomic blog post was successfully destroyed.")
        sign_out the_agent
      end
    end

    scenario "can perform bulk actions" do
      skip "Bulk actions are not permitted for regular users."
      [moderator, admin, superuser].each do |the_agent|
        sign_in the_agent
        visit aurelius_press_admin_document_atomic_blog_posts_path
        expect(current_path).to eq(aurelius_press_admin_document_atomic_blog_posts_path)
        # @todo: Implement bulk actions test
        sign_out the_agent
      end
    end
  end
end
