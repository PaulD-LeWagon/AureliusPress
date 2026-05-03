require "rails_helper"

RSpec.feature "User can manage private notes on a Page", :js do
  let!(:author)    { create(:aurelius_press_user) }
  let!(:user)      { create(:aurelius_press_user) }
  let!(:the_page) do
    create(:aurelius_press_document_page,
           user: author,
           status: :published,
           visibility: :public_to_www,
           comments_enabled: true)
  end

  # ── READ ──────────────────────────────────────────────────────────────────

  scenario "READ - guest does not see the notes section" do
    visit aurelius_press_page_path(the_page)
    expect(page).not_to have_css(".notes-section")
  end

  scenario "READ - authenticated user sees their own notes only" do
    my_note    = create(:aurelius_press_fragment_note, notable: the_page, user: user,   content: "My private page note.")
    other_note = create(:aurelius_press_fragment_note, notable: the_page, user: author, content: "Author page note.")

    sign_in user
    visit aurelius_press_page_path(the_page)

    within ".notes-section" do
      expect(page).to have_content("My private page note.")
      expect(page).not_to have_content("Author page note.")
    end
  end

  # ── CREATE ────────────────────────────────────────────────────────────────

  scenario "CREATE - authenticated user can add a note" do
    sign_in user
    visit aurelius_press_page_path(the_page)

    within ".notes-section" do
      fill_in "Title (optional)", with: "Page observation"
      fill_in_rich_text_area "Note", with: "Something worth remembering."
      click_button "Save note"
      expect(page).to have_content("Something worth remembering.")
    end

    expect(AureliusPress::Fragment::Note.where(user: user).count).to eq(1)
  end
end
