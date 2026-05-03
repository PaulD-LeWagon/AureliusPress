require "rails_helper"

RSpec.feature "User can manage private notes on a Blog Post", :js do
  let!(:author)    { create(:aurelius_press_user) }
  let!(:user)      { create(:aurelius_press_user) }
  let!(:blog_post) do
    create(:aurelius_press_document_blog_post,
           :visible_to_www,
           user: author,
           comments_enabled: true)
  end

  # ── READ ──────────────────────────────────────────────────────────────────

  scenario "READ - guest does not see the notes section" do
    visit aurelius_press_blog_post_path(blog_post)
    expect(page).not_to have_css(".notes-section")
  end

  scenario "READ - authenticated user sees their own notes only" do
    my_note    = create(:aurelius_press_fragment_note, notable: blog_post, user: user, content: "Private note.")
    other_note = create(:aurelius_press_fragment_note, notable: blog_post, user: author, content: "Author note.")

    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    within ".notes-section" do
      expect(page).to have_content("Private note.")
      expect(page).not_to have_content("Author note.")
    end
  end

  # ── CREATE ────────────────────────────────────────────────────────────────

  scenario "CREATE - authenticated user can add a note" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    within ".notes-section" do
      fill_in "Title (optional)", with: "Quick thought"
      fill_in_rich_text_area "Note", with: "Remember this detail."
      click_button "Save note"
      expect(page).to have_content("Remember this detail.")
    end

    expect(AureliusPress::Fragment::Note.where(user: user).count).to eq(1)
  end
end
