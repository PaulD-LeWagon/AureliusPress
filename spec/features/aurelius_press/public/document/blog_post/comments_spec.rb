require "rails_helper"

RSpec.feature "User can manage comments on a Blog Post", :js do
  let!(:author)    { create(:aurelius_press_user) }
  let!(:user)      { create(:aurelius_press_user) }
  let!(:blog_post) do
    create(:aurelius_press_document_blog_post,
           :visible_to_www,
           user: author,
           comments_enabled: true)
  end
  let!(:existing_comment) do
    create(:aurelius_press_fragment_comment,
           commentable: blog_post,
           user: author,
           content: "An existing thought.")
  end

  # ── READ ──────────────────────────────────────────────────────────────────

  scenario "READ - guest can see existing comments" do
    visit aurelius_press_blog_post_path(blog_post)

    within ".comments-section" do
      expect(page).to have_content("An existing thought.")
    end
  end

  scenario "READ - guest does not see the comment form but sees sign-in prompt" do
    visit aurelius_press_blog_post_path(blog_post)
    expect(page).not_to have_css(".comment-form")
    expect(page).to have_link("Sign in")
  end

  scenario "READ - no comments section when comments_enabled is false" do
    post_no_comments = create(:aurelius_press_document_blog_post, :visible_to_www, user: author, comments_enabled: false)
    visit aurelius_press_blog_post_path(post_no_comments)
    expect(page).not_to have_css(".comments-section")
  end

  # ── CREATE ────────────────────────────────────────────────────────────────

  scenario "CREATE - authenticated user can post a comment" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    within ".comments-section" do
      fill_in_rich_text_area "Add a comment", with: "My new comment"
      click_button "Post comment"
      expect(page).to have_content("My new comment")
    end

    expect(AureliusPress::Fragment::Comment.count).to eq(2)
  end

  # ── DELETE ────────────────────────────────────────────────────────────────

  scenario "DELETE - user can delete their own comment" do
    my_comment = create(:aurelius_press_fragment_comment,
                        commentable: blog_post,
                        user: user,
                        content: "To be removed.")

    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    within "##{dom_id(my_comment)}" do
      accept_turbo_confirm { click_link "Delete" }
    end

    expect(page).not_to have_content("To be removed.")
    expect(AureliusPress::Fragment::Comment.with_discarded.discarded).to include(my_comment)
  end

  scenario "DELETE - user cannot delete another user's comment" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    within "##{dom_id(existing_comment)}" do
      expect(page).not_to have_link("Delete")
    end
  end
end
