require "rails_helper"

RSpec.feature "User can manage comments on a Page", :js do
  let!(:author)    { create(:aurelius_press_user) }
  let!(:user)      { create(:aurelius_press_user) }
  let!(:the_page) do
    create(:aurelius_press_document_page,
           user: author,
           status: :published,
           visibility: :public_to_www,
           comments_enabled: true)
  end
  let!(:existing_comment) do
    create(:aurelius_press_fragment_comment,
           commentable: the_page,
           user: author,
           content: "A thought on this page.")
  end

  # ── READ ──────────────────────────────────────────────────────────────────

  scenario "READ - guest can see existing comments" do
    visit aurelius_press_page_path(the_page)

    within ".comments-section" do
      expect(page).to have_content("A thought on this page.")
    end
  end

  scenario "READ - guest sees sign-in prompt instead of form" do
    visit aurelius_press_page_path(the_page)
    expect(page).not_to have_css(".comment-form")
    expect(page).to have_link("Sign in")
  end

  scenario "READ - no comments section when comments_enabled is false" do
    page_no_comments = create(:aurelius_press_document_page, user: author, status: :published, visibility: :public_to_www, comments_enabled: false)
    visit aurelius_press_page_path(page_no_comments)
    expect(page).not_to have_css(".comments-section")
  end

  # ── CREATE ────────────────────────────────────────────────────────────────

  scenario "CREATE - authenticated user can post a comment" do
    sign_in user
    visit aurelius_press_page_path(the_page)

    within ".comments-section" do
      fill_in_rich_text_area "Add a comment", with: "My page comment"
      click_button "Post comment"
      expect(page).to have_content("My page comment")
    end

    expect(AureliusPress::Fragment::Comment.count).to eq(2)
  end

  # ── DELETE ────────────────────────────────────────────────────────────────

  scenario "DELETE - user can delete their own comment" do
    my_comment = create(:aurelius_press_fragment_comment,
                        commentable: the_page,
                        user: user,
                        content: "To be removed from page.")

    sign_in user
    visit aurelius_press_page_path(the_page)

    within "##{dom_id(my_comment)}" do
      accept_turbo_confirm { click_link "Delete" }
    end

    expect(page).not_to have_content("To be removed from page.")
    expect(AureliusPress::Fragment::Comment.with_discarded.discarded).to include(my_comment)
  end

  scenario "DELETE - user cannot delete another user's comment" do
    sign_in user
    visit aurelius_press_page_path(the_page)

    within "##{dom_id(existing_comment)}" do
      expect(page).not_to have_link("Delete")
    end
  end
end
